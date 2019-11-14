(*************************************************************************************)
(* Copyright © zbroyar, 2011                                                         *)
(* Copyright © Joly Clément, 2015                                                    *)
(*                                                                                   *)
(* leowzukw@vmail.me                                                                 *)
(*                                                                                   *)
(* This software is a computer program whose purpose is to pass http requests.       *)
(*                                                                                   *)
(* This software is governed by the CeCILL-C license under French                    *)
(* law and abiding by the rules of distribution of free software.  You can  use,     *)
(* modify and/ or redistribute the software under the terms of the                   *)
(* CeCILL-C license as circulated by CEA, CNRS and INRIA at the                      *)
(* following URL "http://www.cecill.info".                                           *)
(*                                                                                   *)
(* As a counterpart to the access to the source code and  rights to copy, modify     *)
(* and redistribute granted by the license, users are provided only with a limited   *)
(* warranty  and the software's author,  the holder of the economic rights,  and     *)
(* the successive licensors  have only  limited liability.                           *)
(*                                                                                   *)
(* In this respect, the user's attention is drawn to the risks associated with       *)
(* loading,  using,  modifying and/or developing or reproducing the software by the  *)
(* user in light of its specific status of free software, that may mean  that it is  *)
(* complicated to manipulate,  and  that  also therefore means  that it is reserved  *)
(* for developers  and  experienced professionals having in-depth computer           *)
(* knowledge. Users are therefore encouraged to load and test the software's         *)
(* suitability as regards their requirements in conditions enabling the security of  *)
(* their systems and/or data to be ensured and,  more generally, to use and operate  *)
(* it in the same conditions as regards security.                                    *)
(*                                                                                   *)
(* The fact that you are presently reading this means that you have had knowledge    *)
(* of the CeCILL-C license and that you accept its terms.                            *)
(*                                                                                   *)
(*************************************************************************************)

(** Inspired by https://gist.github.com/zbroyar/1432555 *)

(* Global initialisation *)
let _ = Curl.global_init Curl.CURLINIT_GLOBALALL

(* Type to return *)
type answer =
    {
        rc: int; (* response code *)
        content: string;
    }
;;

(*
 *************************************************************************
 ** Aux. functions
 *************************************************************************
 *)

let writer_callback a d =
    Buffer.add_string a d;
    String.length d

let init_conn ~user_agent ?(verbose=false) url =
    (* Options *)
    let user_agent =  (function None -> "" | Some s -> s) user_agent in
    (*  *)
    let buffer = Buffer.create 16384
    and curl = Curl.init () in
    Curl.set_timeout curl 1200;
    Curl.set_useragent curl user_agent;
    Curl.set_sslverifypeer curl false;
    Curl.set_sslverifyhost curl Curl.SSLVERIFYHOST_EXISTENCE;
    Curl.set_writefunction curl (writer_callback buffer);
    Curl.set_tcpnodelay curl true;
    Curl.set_verbose curl verbose;
    Curl.set_post curl false;
    Curl.set_url curl url;
    buffer,curl
;;

(* GET *)
let get ?user_agent url =
    let buffer,curl = init_conn ~user_agent url in
    Curl.set_followlocation curl true;
    Curl.perform curl;
    let rc = Curl.get_responsecode curl in
    Curl.cleanup curl;
    {
        rc;
        content = (Buffer.contents buffer)
    }
;;

(* POST *)
let post ?user_agent ?(content_type = "text/html") ~data url =
    let buffer,curl = init_conn ~user_agent url in
    Curl.set_post curl true;
    Curl.set_httpheader curl [ "Content-Type: " ^ content_type ];
    Curl.set_postfields curl data;
    Curl.set_postfieldsize curl (String.length data);
    Curl.perform curl;
    let rc = Curl.get_responsecode curl in
    Curl.cleanup curl;
    {
        rc;
        content = (Buffer.contents buffer)
    }
;;

(* PUT *)
let put ?user_agent ?(content_type = "text/html") ~data url =
    let pos = ref 0
    and len = String.length data in
    let rf cnt =
        let can_send = len - !pos in
        let to_send = if can_send > cnt then cnt else can_send in
        let r = String.sub data !pos to_send in
        pos := !pos + to_send; r
    and buffer,curl = init_conn ~user_agent url in
    Curl.set_put curl true;
    Curl.set_upload curl true;
    Curl.set_readfunction curl rf;
    Curl.set_httpheader curl [ "Content-Type: " ^ content_type ];
    Curl.perform curl;
    let rc = Curl.get_responsecode curl in
    Curl.cleanup curl;
    {
        rc;
        content = (Buffer.contents buffer)
    }
;;

(* DELETE *)
let delete ?user_agent url =
    let buffer,curl = init_conn ~user_agent url in
    Curl.set_customrequest curl "DELETE";
    Curl.set_followlocation curl false;
    Curl.perform curl;
    let rc = Curl.get_responsecode curl in
    Curl.cleanup curl;
    {
        rc;
        content = (Buffer.contents buffer)
    }
;;

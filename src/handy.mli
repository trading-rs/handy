(*************************************************************************************)
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

(** The library Simple OCurl provides easy to use interface for the OCurl
 * library. *)

(** Type of the answers *)
type answer =
    {
        rc: int; (* response code *)
        content: string;
    }
;;

(** GET function *)
val get : ?user_agent:string -> string -> answer

(** POST function *)
val post : ?user_agent:string -> ?content_type:string -> data:string -> string -> answer

(** PUT function *)
val put : ?user_agent:string -> ?content_type:string -> data:string -> string -> answer

(** DELTE  function *)
val delete : ?user_agent:string -> string -> answer

open Handy

let check () =
    let resp = get "https://www.baidu.com" in
    Printf.printf "%d -> %s\n" resp.rc resp.content

let () = check ()

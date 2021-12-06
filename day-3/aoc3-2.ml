let to_bit c = 
  match c with
  | '0' -> Some 0
  | '1' -> Some 1
  | _ -> None in
let to_char_list s = List.init (String.length s) (fun i -> s.[i]) in 
let to_bit_list s =
  s
  |> to_char_list
  |> List.filter_map to_bit in 

let rec read_lines () =
  match input_line stdin with
  | line -> line :: read_lines ()
  | exception End_of_file -> [] in

let bit_strings = read_lines () in
let bit_lists = List.map to_bit_list bit_strings in

let update_count (zeros, ones) l = 
  let bit = List.hd l in
  if bit = 0 then 
    (zeros + 1, ones) 
  else 
    (zeros, ones + 1) in
let first_bit_count l = List.fold_left update_count (0, 0) l in 

let starts_with bit bit_list =
  match bit_list with
  | [] -> false
  | h :: _ -> h = bit in 

let rec process get_deciding_bit bit_lists =
  match bit_lists with
  | [] -> []
  | h :: [] -> h
  | l ->
      let deciding_bit = get_deciding_bit l in 
      let filtered = List.filter (starts_with deciding_bit) l in
      deciding_bit :: process get_deciding_bit (List.map List.tl filtered) in

let get_most_common_first_bit l = 
  let (zeros, ones) = first_bit_count l in
  if ones >= zeros then 1 else 0 in

let get_least_common_first_bit l = 
  1 - get_most_common_first_bit l in 

let f acc bit = 2 * acc + bit in
let bit_list_to_int l = List.fold_left f 0 l in

let oxygen = bit_lists
             |> process get_most_common_first_bit
             |> bit_list_to_int in

let co2 = bit_lists
          |> process get_least_common_first_bit
          |> bit_list_to_int in

oxygen * co2
|> print_int

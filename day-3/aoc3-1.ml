type counter = {freq: int list; total: int}

let empty_counter = {freq = []; total = 0} 

let to_bit c = 
    match c with
        | '0' -> Some 0
        | '1' -> Some 1
        | _ -> None

let to_char_list s = List.init (String.length s) (fun i -> s.[i])

let to_bit_list s =
    s
    |> to_char_list
    |> List.filter_map to_bit 

let add_lists a b = if a = [] then b else List.map2 (fun a1 b1 -> a1 + b1) a b

let update_counter ctr freq_list = { 
    freq = add_lists ctr.freq freq_list; 
    total = ctr.total + 1
}

let to_counter bit_lists = List.fold_left update_counter empty_counter bit_lists

let most_common_bit total bit_sum = if 2 * bit_sum > total then 1 else 0

let most_common_bit_list ctr = List.map (most_common_bit ctr.total) ctr.freq

let rec read_lines () =
    match input_line stdin with
        | line -> line :: read_lines ()
        | exception End_of_file -> [];;

let bit_strings = read_lines ();;

let most_common_bits = bit_strings
    |> List.map to_bit_list
    |> to_counter
    |> most_common_bit_list;;

let gamma = List.fold_left (fun acc bit -> 2 * acc + bit) 0 most_common_bits;;

let epsilon = List.fold_left (fun acc bit -> 2 * acc + 1 - bit) 0 most_common_bits;;

print_int (gamma * epsilon);;

# Demo - Writing functions in the Puppet language.
function demo::mary_poppinsify($fmt, *$str) {
    "${String($str, $fmt)}. These are a few of my favourite things.\n"
}

const possible_company_ids = [
    85,78,67,35,
    54,40,80,10,
    34,83,68,42,
    8,9,23,53,
    21,77,24,14,
    79,28,33,7,
    49,19,6,37,
    55,13,1,18,
    30,51,26,27,
    81,29,17,11,
    69,31,44,43,
    39,22,5,57,
    32,41,87,74,
    63,59,52,46
]

function randomCompanyId(){
    return possible_company_ids[Math.floor(Math.random() * possible_company_ids.length)]
}


module.exports = {
    randomCompanyId
}

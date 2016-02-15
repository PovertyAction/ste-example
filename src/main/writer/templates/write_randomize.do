version <%= strofreal(callersversion()) %>

set seed <%= seed %>

use "<%= dataset %>", clear

<% if (sample != "") { %>
sample <%= sample %>, count

<% } %>
isid <%= unique %>
sort <%= unique %>

generate double u1 = runiform()
generate double u2 = runiform()

isid u1 u2
sort u1 u2

generate treatment = mod(_n - 1, <%= groups %>) + 1

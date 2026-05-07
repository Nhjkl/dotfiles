local headers = require("utils.dashboard_headers")

return {
  "goolord/alpha-nvim",
  opts = function(_, dashboard)
    headers.setHeaders(dashboard)
  end,
}

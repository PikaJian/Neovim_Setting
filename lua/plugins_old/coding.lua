--This plugin make nvim starup slow
--[[ require('ts_context_commentstring').setup {
    enable_autocmd = false,
    config = {
        c =  { __default = '//%s', __multiline = '/* %s */'}
    }
}

require('comment').setup {
  pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
} ]]

require('Comment').setup()

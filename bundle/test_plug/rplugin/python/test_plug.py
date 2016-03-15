import neovim

@neovim.plugin
class Limit(object):
    def __init__(self, vim):
        self.vim = vim
        self.calls = 0
    @neovim.function('Test_Func')
    def Test_Func(self, arg):
        s = dir(self.vim.funcs.nvim.func)
        s = 'echom \"' + str(s) + '\"'
        self.vim.command(s)
        '''
        i = self.vim.command('call getchar()')
        self.vim.command('redraw')
        i = self.vim.command('call nr2char(%d)' %i)
        s = 'echom \"result:' + i + '\"'
        self.vim.command(s)
        '''

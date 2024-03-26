local ls = require("luasnip") -- 加载 LuaSnip
local s = ls.snippet -- 定义片段
local t = ls.text_node -- 文本节点
local i = ls.insert_node -- 插入节点
local fmt = require("luasnip.extras.fmt").fmt -- 格式化函数

ls.add_snippets("c", {
    -- 复杂的 C 函数注释块
    s("/**", {
        t("/**"),
        t({" * ", ""}), i(1, "A one-line summary."),
        t({" *", " * ", ""}), i(2, "Description."),
        t({" *", " * @param "}), i(4, "name"), t(" "), i(5, "Type and description of the parameter."),
        t({" * @return "}), i(3, "Type and description of the returned value."),
        t({" *", " * @example", " * // "}), i(6, "Description of my example."),
        t({"", " * "}), i(7, "Write me later"),
        t({"", " */"}),
    }),
    -- 简单的 C 函数注释块
    s("/*", {
        t("/**"),
        t({" * ", ""}), i(1, "A one-line summary."),
        t({" *", " * ", ""}), i(2, "Description."),
        t(" */"),
    }),
    -- @param
    s("param", {
        t("param "), i(1, "name"), t(" "), i(2, "Type and description of the parameter."),
    }),
    -- 其他片段可以用相同的模式定义
    -- 确保更新 `ls.add_snippets` 调用中的第一个参数以匹配你想要片段在其中生效的语言
    -- @todo 片段
    s("todo", {
        t("// TODO: "), i(1, "Text.")
    }),
    -- @fixme 片段
    s("fixme", {
        t("// FIXME: "), i(1, "Text.")
    }),
})

return {
    "seblyng/roslyn.nvim",
    ---@module 'roslyn.config'
    ---@type RoslynNvimConfig
    opts = {
        -- your configuration comes here; leave empty for default settings
        settings = {
            ["csharp.inlayHints"] = {
                csharp_enable_inlay_hints_for_implicit_object_creation = true,
                csharp_enable_inlay_hints_for_implicit_variable_types = true,
                csharp_enable_inlay_hints_for_lambda_parameter_types = true,
                csharp_enable_inlay_hints_for_types = true,
                dotnet_enable_inlay_hints_for_indexer_parameters = true,
                dotnet_enable_inlay_hints_for_literal_parameters = true,
                dotnet_enable_inlay_hints_for_object_creation_parameters = true,
                dotnet_enable_inlay_hints_for_other_parameters = true,
                dotnet_enable_inlay_hints_for_parameters = true,
            },
            ["csharp.completion"] = {
                addImport = { allowReferences = true },
            },
            ["dotnet.completion"] = {
                provideSuggestionSupport = true,
            },
            ["csharp.backgroundAnalysis"] = {
                dotnet_analyzer_diagnostics_scope = "fullSolution",
                dotnet_compiler_diagnostics_scope = "fullSolution",
            },
        },
        vim.lsp.config("roslyn", {
            cmd = {
                "dotnet",
                "/nix/store/din99b4x7v99w1cny76fpf90kw83s3kj-roslyn-ls-5.0.0-1.25312.6/lib/roslyn-ls/Microsoft.CodeAnalysis.LanguageServer.dll",
                "--logLevel=Information",
                "--extensionLogDirectory=/home/stein",
                "--stdio",
            },
        }),
    },
}

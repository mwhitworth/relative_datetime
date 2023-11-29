
checks =
  [
    Credo.Check.Readability.OneArityFunctionInPipe,
    # Credo.Check.Readability.OnePipePerLine,
    Credo.Check.Refactor.FilterCount,
    Credo.Check.Refactor.PassAsyncInTestCases,
    Credo.Check.Warning.MissedMetadataKeyInLoggerConfig,
    Credo.Check.Design.DuplicatedCode,
    Credo.Check.Design.TagFIXME,
    Credo.Check.Design.TagTODO,
    Credo.Check.Readability.AliasOrder,
    Credo.Check.Readability.FunctionNames,
    Credo.Check.Readability.LargeNumbers,
    Credo.Check.Readability.MaxLineLength,
    Credo.Check.Readability.ModuleAttributeNames,
    Credo.Check.Readability.ModuleNames,
    Credo.Check.Readability.ParenthesesInCondition,
    Credo.Check.Readability.ParenthesesOnZeroArityDefs,
    Credo.Check.Readability.PredicateFunctionNames,
    Credo.Check.Readability.PreferImplicitTry,
    Credo.Check.Readability.RedundantBlankLines,
    Credo.Check.Readability.Semicolons,
    Credo.Check.Readability.SeparateAliasRequire,
    Credo.Check.Readability.SpaceAfterCommas,
    Credo.Check.Readability.StrictModuleLayout,
    Credo.Check.Readability.StringSigils,
    Credo.Check.Readability.TrailingBlankLine,
    Credo.Check.Readability.TrailingWhiteSpace,
    Credo.Check.Readability.UnnecessaryAliasExpansion,
    Credo.Check.Readability.VariableNames,
    # Credo.Check.Readability.WithCustomTaggedTuple,
    # Credo.Check.Refactor.ABCSize,
    Credo.Check.Refactor.CondStatements,
    Credo.Check.Refactor.CyclomaticComplexity,
    Credo.Check.Refactor.DoubleBooleanNegation,
    Credo.Check.Refactor.FunctionArity,
    Credo.Check.Refactor.LongQuoteBlocks,
    Credo.Check.Refactor.MatchInCondition,
    # Credo.Check.Refactor.ModuleDependencies,
    Credo.Check.Refactor.NegatedConditionsInUnless,
    Credo.Check.Refactor.NegatedConditionsWithElse,
    Credo.Check.Refactor.Nesting,
    Credo.Check.Refactor.PerceivedComplexity,
    Credo.Check.Refactor.UnlessWithElse,
    Credo.Check.Refactor.WithClauses,
    Credo.Check.Warning.ApplicationConfigInModuleAttribute,
    Credo.Check.Warning.BoolOperationOnSameValues,
    Credo.Check.Warning.ExpensiveEmptyEnumCheck,
    Credo.Check.Warning.IExPry,
    Credo.Check.Warning.IoInspect,
    Credo.Check.Warning.LeakyEnvironment,
    Credo.Check.Warning.MapGetUnsafePass,
    Credo.Check.Warning.MixEnv,
    Credo.Check.Warning.OperationOnSameValues,
    Credo.Check.Warning.OperationWithConstantResult,
    Credo.Check.Warning.RaiseInsideRescue,
    Credo.Check.Warning.UnsafeExec,
    Credo.Check.Warning.UnusedEnumOperation,
    Credo.Check.Warning.UnusedFileOperation,
    Credo.Check.Warning.UnusedKeywordOperation,
    Credo.Check.Warning.UnusedListOperation,
    Credo.Check.Warning.UnusedPathOperation,
    Credo.Check.Warning.UnusedRegexOperation,
    Credo.Check.Warning.UnusedStringOperation,
    Credo.Check.Warning.UnusedTupleOperation,
    Credo.Check.Consistency.LineEndings,
    Credo.Check.Consistency.ParameterPatternMatching,
    Credo.Check.Consistency.SpaceAroundOperators,
    Credo.Check.Consistency.SpaceInParentheses,
    Credo.Check.Consistency.TabsOrSpaces
  ]
  |> Enum.map(&{&1, priority: :normal})

# The following checks have been decided against.
# Credo.Check.Design.AliasUsage,
# Credo.Check.Consistency.UnusedVariableNames
# Credo.Check.Consistency.MultiAliasImportRequireUse,
# Credo.Check.Readability.SinglePipe,
# Credo.Check.Readability.BlockPipe,
# Credo.Check.Readability.ImplTrue,
# Credo.Check.Readability.AliasAs,
# Credo.Check.Readability.MultiAlias,
# Credo.Check.Refactor.AppendSingleItem,
# Credo.Check.Refactor.PipeChainStart,
# Credo.Check.Refactor.VariableRebinding,
# Credo.Check.Refactor.NegatedIsNil,
# Credo.Check.Warning.UnsafeToAtom,

# The following checks are not compatible with our version of Elixir
# Credo.Check.Readability.PreferUnquotedAtoms
# Credo.Check.Refactor.MapInto
# Credo.Check.Warning.LazyLogging

checks =
  checks ++
    [
      {Credo.Check.Readability.Specs, files: %{excluded: ["priv/*_repo/"]}},
      {Credo.Check.Consistency.ExceptionNames, false}
    ]

%{
  configs: [
    %{
      name: "default",
      checks: checks,
      files: %{
        included: ["lib/", "test/", "priv/*_repo/"]
      }
    }
  ]
}

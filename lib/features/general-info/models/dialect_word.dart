class DialectWord {
  final Map<String, String> localizations; // standard meaning (kk, ru, en)
  final Map<String, String> regionDialects; // dialect word by region
  final Map<String, String> meanings; // localized meanings
  final Map<String, List<String>> examples; // localized example sentences (list for multiple examples)

  DialectWord({
    required this.localizations,
    required this.regionDialects,
    required this.meanings,
    required this.examples,
  });
}

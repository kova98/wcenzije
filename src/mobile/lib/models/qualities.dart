class Qualities {
  bool hasSoap;
  bool hasToiletPaper;
  bool hasPaperTowels;
  bool isClean;

  Qualities({
    this.hasSoap = false,
    this.hasToiletPaper = false,
    this.hasPaperTowels = false,
    this.isClean = false,
  });

  Map<String, dynamic> toMap() => <String, dynamic>{
        "hasSoap": hasSoap,
        "hasToiletPaper": hasToiletPaper,
        "hasPaperTowels": hasPaperTowels,
        "isClean": isClean,
      };

  Qualities.fromJson(Map<String, dynamic> parsedJson)
      : hasPaperTowels = parsedJson['hasPaperTowels'] ?? false,
        hasSoap = parsedJson['hasSoap'] ?? false,
        hasToiletPaper = parsedJson['hasToiletPaper'] ?? false,
        isClean = parsedJson['isClean'] ?? false;
}

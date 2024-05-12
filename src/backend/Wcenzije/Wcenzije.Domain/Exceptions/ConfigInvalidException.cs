namespace Wcenzije.Domain.Exceptions;

public class ConfigInvalidException(string key, string value, string reason) : Exception(
    $"Config invalid for key: '{key}' with value: '{value}'. " +
    $"Reason: {reason}. ");
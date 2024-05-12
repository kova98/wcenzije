namespace Wcenzije.Domain.Exceptions;

public class ConfigMissingException(string key)
    : Exception($"Config missing for key: '{key}'. Check appSettings and env variables.");
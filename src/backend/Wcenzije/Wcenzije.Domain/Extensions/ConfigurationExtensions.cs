using Microsoft.Extensions.Configuration;
using Wcenzije.Domain.Exceptions;

namespace Wcenzije.Domain.Extensions;

public static class ConfigurationExtensions
{
    public static string TryGet(this IConfiguration config, string key)
    {
        var value = config[key];
        if (string.IsNullOrWhiteSpace(value))
        {
            throw new ConfigMissingException(key);
        }

        return value;
    }
}
using Microsoft.Extensions.Configuration;
using Wcenzije.Domain.Exceptions;
using Wcenzije.Domain.Extensions;

namespace Wcenzije.Tests.Domain;

public class ConfigurationExtensionsTests
{
    private readonly IConfiguration _configuration = Substitute.For<IConfiguration>();
    
    [Fact]
    public void TryGet_ValueSet_ReturnsValue()
    {
        _configuration["test"].Returns("test value");
        
        var result = _configuration.TryGet("test");
        
        result.Should().Be("test value");
    }
    
    [Fact]
    public void TryGet_ValueNotSet_ThrowsException()
    {
        _configuration["test"].Returns((string)null);
        
        Action act = () => _configuration.TryGet("test");
        
        act.Should().Throw<ConfigMissingException>();
    }
}
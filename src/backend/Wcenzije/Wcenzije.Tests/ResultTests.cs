using Microsoft.AspNetCore.Http.HttpResults;
using Wcenzije.API;
using Wcenzije.Domain;

namespace Wcenzije.Tests;

public record TestResult(string Name);

public class ResultTests
{
    [Fact]
    public void OkWithType_ToHttpResult_ShouldMapToOkWithBody()
    {
        var okResult = Result<TestResult>.Ok(new TestResult("Test"));
        
        var result = okResult.ToHttpResult();
        
        result.Should().BeOfType<Ok<TestResult>>().Which.Value?.Name.Should().Be("Test");
    }
    
    [Fact]
    private void OkWithNoType_ToHttpResult_ShouldMapToNoContent()
    {
        var okResult = Result.Ok();
        
        var result = okResult.ToHttpResult();
        
        result.Should().BeOfType<NoContent>();
    }
    
    [Fact]
    public void CreatedWithType_ToHttpResult_ShouldMapToCreatedWithLocation()
    {
        var id = Guid.NewGuid();
        var createdResult = Result<Guid>.Created(id);
        
        var result = createdResult.ToHttpResult("subscriber");
        
        result.Should().BeOfType<Created>().Which.Location.Should().Be($"subscriber/{id}");
    }
    
    [Fact]
    public void FailWithType_ToHttpResult_ShouldMapToBadRequestWithError()
    {
        var failResult = Result<Guid>.Fail("Test");
        
        var result = failResult.ToHttpResult();
        
        result.Should().BeOfType<BadRequest<ErrorBody>>().Which!.Value!.Error.Should().Be("Test");
    }
    
    [Fact]
    public void FailWithNoType_ToHttpResult_ShouldMapToBadRequest()
    {
        var failResult = Result.Fail("Test");
        
        var result = failResult.ToHttpResult();
        
        result.Should().BeOfType<BadRequest<ErrorBody>>();
    }
    
    [Fact]
    public void UnauthorizedWithType_ToHttpResult_ShouldMapToUnauthorizedWithError()
    {
        var unauthorizedResult = Result<Guid>.Unauthorized();
        
        var result = unauthorizedResult.ToHttpResult();
        
        result.Should().BeOfType<UnauthorizedHttpResult>();
    }
    
    [Fact]
    public void UnauthorizedWithNoType_ToHttpResult_ShouldMapToUnauthorized()
    {
        var unauthorizedResult = Result.Unauthorized();
        
        var result = unauthorizedResult.ToHttpResult();
        
        result.Should().BeOfType<UnauthorizedHttpResult>();
    }
}
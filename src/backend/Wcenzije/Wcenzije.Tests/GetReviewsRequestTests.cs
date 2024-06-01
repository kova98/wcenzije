using Wcenzije.API.Models.Review;

namespace Wcenzije.Tests;

public class GetReviewsRequestTests
{
    [Theory]
    [InlineData("")]
    [InlineData("  ")]
    [InlineData(null)]
    public void IdsArray_ReturnsEmpty_WhenIdsIsNullOrEmpty(string ids)
    {
        var request = new GetReviewsRequest { Ids = ids };
        
        var result = request.IdsArray;
        
        result.Should().BeEmpty();
    }
    
    [Fact]
    public void IdsArray_ReturnsIdsArray_WhenIdsIsNotEmpty()
    {
        var request = new GetReviewsRequest { Ids = "1,2,3" };
        
        var result = request.IdsArray;
        
        result.Should().BeEquivalentTo(new long[] { 1, 2, 3 });
    }
}
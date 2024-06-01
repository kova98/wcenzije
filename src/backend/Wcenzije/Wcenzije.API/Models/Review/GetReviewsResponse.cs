using Wcenzije.Domain.Models;

namespace Wcenzije.API.Models.Review;

public class GetReviewsResponse
{
    public int Page { get; set; }
    public int PageSize { get; set; }
    public int TotalCount { get; set; }
    public IEnumerable<Domain.Entities.Review> Reviews { get; set; }
    
    public GetReviewsResponse(PagedResult<Domain.Entities.Review> pagedResult)
    {
        Page = pagedResult.Page;
        PageSize = pagedResult.PageSize;
        TotalCount = pagedResult.TotalCount;
        Reviews = pagedResult.Data;
    }
}
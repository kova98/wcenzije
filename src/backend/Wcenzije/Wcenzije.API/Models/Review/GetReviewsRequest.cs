namespace Wcenzije.API.Models.Review;

public class GetReviewsRequest
{
    public int Page { get; set; } = 1;
    public int PageSize { get; set; } = 10;
    public string Ids { get; set; }
    
    public IEnumerable<long> IdsArray
    {
        get
        {
            if (string.IsNullOrEmpty(Ids))
            {
                yield break;
            }
            
            foreach (var id in Ids.Split(','))
            {
                if (long.TryParse(id, out var result))
                {
                    yield return result;
                }
            }
        }
    }
}
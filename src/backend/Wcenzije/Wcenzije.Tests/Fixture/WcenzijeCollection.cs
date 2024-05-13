namespace Wcenzije.Tests;

[CollectionDefinition(Name)]
public class WcenzijeCollection : ICollectionFixture<IntegrationTestFixture>
{
    public const string Name = "Wcenzije Collection";
    
    // Class used only for Collection Definition
}
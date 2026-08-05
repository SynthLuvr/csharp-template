using TUnit.Core;

namespace CSharpTemplate.Tests;

public class GreeterTests
{
    [Test]
    public async Task GreetReturnsGreeting()
    {
        var result = Greeter.Greet();
        await Assert.That(result).IsEqualTo("hello");
    }

    [Test]
    public async Task ToLabelLabelsString()
    {
        var result = Greeter.ToLabel("x");
        await Assert.That(result).IsEqualTo("label: x");
    }

    [Test]
    public async Task ToLabelLabelsNumber()
    {
        var result = Greeter.ToLabel(42);
        await Assert.That(result).IsEqualTo("label: 42");
    }
}

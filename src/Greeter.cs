namespace CSharpTemplate;

public static class Greeter
{
    public static string Greet() => "hello";

    public static string ToLabel(string value) => $"label: {value}";

    public static string ToLabel(int value) => $"label: {value}";
}

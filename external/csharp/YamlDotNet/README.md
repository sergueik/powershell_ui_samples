### Info

This directory contains a replica of 
[aaubry/YamlDotNet](https://github.com/aaubry/YamlDotNet)
downgraded to compileto .NEt 2.x , 4.x 
and stripped from it Docker part etc.
### Motivition:

Intended to make modifications o the following code in `Emitter.cs` flexible
```csharp
foreach (var tagDirective in documentTagDirectives){
    AppendTagDirectiveTo(tagDirective, false, tagDirectives);
}

foreach (var tagDirective in Constants.DefaultTagDirectives){
    AppendTagDirectiveTo(tagDirective, true, tagDirectives);
}

if (documentTagDirectives.Count > 0){
    isImplicit = false;
    foreach (var tagDirective in Constants.DefaultTagDirectives){
        AppendTagDirectiveTo(tagDirective, true, documentTagDirectives);
    }
```
where `allowDuplicates` is not currently available for caller to define.
```csharp
private static void AppendTagDirectiveTo(TagDirective value, bool allowDuplicates, TagDirectiveCollection tagDirectives){
    if (tagDirectives.Contains(value)){
        if (!allowDuplicates) {
            throw new YamlException("Duplicate %TAG directive.");
        }
```
to allow the YamlDotNet continue inspecting the code despite the duplication of some keys descrrbing environment specific alternativer but not really formatted as such.

Note: the `YamlDotNet.Serialization.SerializationOptions` class exists but does not offer this  particular behavior configurable.
The other alternative to explore is allow `YamlDotNet.RepresentationModel.YamlStream` continue after the `YamlException.YamlExcepion`

To make it easier one has first to roll back into the older __YamlDotNet__versions prior to __Version 4.2.0__ when the multiplatform support was added therefore making it harder to build the roject e.g. in SharpDevelop,
e.g. __Version 3.5.0__

Later was found that due to somewhat nonstandard DOM of the project files used, an even older version of the  projct is a safe start.
was teken __Version 2.0.1__

### Author
[Serguei Kouzmine](kouzmine_serguei@yahoo.com)

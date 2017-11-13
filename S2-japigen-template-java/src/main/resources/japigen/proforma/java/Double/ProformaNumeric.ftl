<#assign subTemplateName="${.current_template_name!''}"><#include "../S2-japigen-template-java-SubPrologue.ftl">
public class ${model.camelCapitalizedName} extends ${model.camelCapitalizedName}ModelType
{
  public ${model.camelCapitalizedName}(${javaType} value)
  {
    super(value);
  }
}
<#assign subTemplateName="${.current_template_name!''}"><#include "../S2-japigen-template-java-SubEpilogue.ftl">
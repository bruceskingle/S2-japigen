<#assign subTemplateName="${.current_template_name!''}"><#include "S2-japigen-proforma-java-SubPrologue.ftl">
<#if model.attributes['javaExternalType']??>
<#assign methodAnnotation="">
<#else>
<#assign methodAnnotation="@Override">
import ${javaGenPackage}.${model.camelCapitalizedName}ModelType;
</#if>

// javaType = ${javaType}
// javaBaseType = ${javaBaseType}
<#include "../../template/java/TypeDefHeader.ftl">
<#if model.attributes['javaExternalType']??>
public class ${model.camelCapitalizedName}
{
  // This type is defined with an external type ${javaFacadeFullyQualifiedName}.
  private ${model.camelCapitalizedName}()
  {}
  
  public static class Builder
  {
<#else>
public class ${model.camelCapitalizedName} extends ${model.camelCapitalizedName}ModelType
{
  public ${model.camelCapitalizedName}(${javaType} value)
  {
    super(value);
  }
  
  public static class Builder extends ${model.camelCapitalizedName}ModelType.Builder
  {
</#if>
    ${methodAnnotation}
    public ${model.camelCapitalizedName} build(${javaBaseType} value)
    {
      return new ${model.camelCapitalizedName}(value);
    }
    
    ${methodAnnotation}
    public ${javaBaseType} to${javaBaseType}(${model.camelCapitalizedName} instance)
    {
      return instance.getValue();
    }
  }
<#assign subTemplateName="${.current_template_name!''}"><#include "S2-japigen-proforma-java-SubEpilogue.ftl">
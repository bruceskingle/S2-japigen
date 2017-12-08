<#assign subTemplateName="${.current_template_name!''}"><#include "S2-japigen-proforma-java-SubPrologue.ftl">
import org.symphonyoss.s2.common.exception.BadFormatException;

import ${javaGenPackage}.${modelJavaClassName}ModelType;

<#include "../../template/java/TypeDefHeader.ftl">
public class ${modelJavaClassName} extends ${modelJavaClassName}ModelType
{
  public ${modelJavaClassName}(${modelJavaFieldClassName} value)<@checkLimitsThrows model/>
  {
    super(value);
  }
  
  public static class Builder extends ${modelJavaClassName}ModelType.Builder
  {
    @Override
    public ${modelJavaClassName} build(${modelJavaFieldClassName} value)<@checkLimitsThrows model/>
    {
      return new ${modelJavaClassName}(value);
    }
    
    @Override
    public ${modelJavaFieldClassName} to${modelJavaFieldClassName}(${modelJavaClassName} instance)
    {
      return instance.getValue();
    }
  }

<#---
OLD GENERATION

<#if model.attributes['javaExternalType']??>
<#assign methodAnnotation="">
<#else>
<#assign methodAnnotation="@Override">
import org.symphonyoss.s2.common.exception.BadFormatException;

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
  public ${model.camelCapitalizedName}(${javaType} value)<@checkLimitsThrows model/>
  {
    super(value);
  }
  
  public static class Builder extends ${model.camelCapitalizedName}ModelType.Builder
  {
</#if>
    ${methodAnnotation}
    public ${model.camelCapitalizedName} build(${javaBaseType} value)<@checkLimitsThrows model/>
    {
      return new ${model.camelCapitalizedName}(value);
    }
    
    ${methodAnnotation}
    public ${javaBaseType} to${javaBaseType}(${model.camelCapitalizedName} instance)
    {
      return instance.getValue();
    }
  }
---->
<#assign subTemplateName="${.current_template_name!''}"><#include "S2-japigen-proforma-java-SubEpilogue.ftl">
<#assign subTemplateName="${.current_template_name!''}"><#include "S2-japigen-template-java-SubPrologue.ftl">
import org.symphonyoss.s2.common.exception.BadFormatException;

import ${javaFacadePackage}.${modelJavaClassName};

<#include "TypeDefHeader.ftl">

public class ${modelJavaClassName}ModelType
{
  private ${modelJavaFieldClassName} value_;
  
  public ${modelJavaClassName}ModelType(${modelJavaFieldClassName} value)<#if model.canFailValidation> throws BadFormatException</#if>
  {
<@checkLimits model "value"/>
    value_ = value;
  }
  
  public ${modelJavaFieldClassName} getValue()
  {
    return value_;
  }
  
  public static abstract class Builder
  {
    public abstract ${modelJavaClassName} build(${modelJavaFieldClassName} value)<#if model.canFailValidation> throws BadFormatException</#if>;
    public abstract ${modelJavaFieldClassName} to${modelJavaFieldClassName}(${modelJavaClassName} instance);
  }
<#-----
old generation to be deleted


className ${model.class.name}
canFailValidation ${model.canFailValidation?c}


public class ${model.camelCapitalizedName}ModelType
{
<#if model.attributes['javaExternalType']??>
  // This type is defined with an external type ${javaFacadeFullyQualifiedName}.
  private ${model.camelCapitalizedName}ModelType()
  {}
<#else>
  private ${javaType} value_;
  
  public ${model.camelCapitalizedName}ModelType(${javaBaseType} value)<@checkLimitsThrows model/>
  {
<@checkLimits model "value"/>
    value_ = value;
  }
  
  public ${javaType} getValue()
  {
    return value_;
  }
  
  public static abstract class Builder
  {
    public abstract ${model.camelCapitalizedName} build(${javaBaseType} value)<@checkLimitsThrows model/>;
    public abstract ${javaType} to${javaType}(${model.camelCapitalizedName} instance);
  }
</#if>
---->
<#assign subTemplateName="${.current_template_name!''}"><#include "S2-japigen-template-java-SubEpilogue.ftl">
<#assign subTemplateName="${.current_template_name!''}"><#include "S2-japigen-template-java-SubPrologue.ftl">
import javax.annotation.concurrent.Immutable;

import com.google.protobuf.ByteString;

import org.symphonyoss.s2.common.dom.IBooleanProvider;
import org.symphonyoss.s2.common.dom.IStringProvider;
import org.symphonyoss.s2.common.dom.IIntegerProvider;
import org.symphonyoss.s2.common.dom.ILongProvider;
import org.symphonyoss.s2.common.dom.IFloatProvider;
import org.symphonyoss.s2.common.dom.IDoubleProvider;
import org.symphonyoss.s2.common.dom.IByteStringProvider;
import org.symphonyoss.s2.common.dom.json.IJsonDomNode;

import org.symphonyoss.s2.common.exception.BadFormatException;

import ${javaFacadePackage}.${modelJavaClassName};

<#include "TypeDefHeader.ftl">
<@setJavaType model/>
@Immutable
public class ${modelJavaClassName}ModelType
{
  private ${modelJavaFieldClassName} value_;

  protected ${modelJavaClassName}ModelType(${modelJavaFieldClassName} value)<#if model.canFailValidation> throws BadFormatException</#if>
  {
<@checkLimits "    " model "value"/>
    value_ = value;
  }

  <#-- Constructor from Json   -->  
  protected ${modelJavaClassName}ModelType(IJsonDomNode node) throws BadFormatException
  {
  <#switch model.elementType>
    <#case "Ref">
    value_ = ${javaConstructTypePrefix}node${javaConstructTypePostfix};
      <#break>
      
    <#case "Array">
    I dont think this can ever be
    if(node instanceof JsonArray)
    {
      value_ = ((JsonArray<?>)node).asImmutable${javaCardinality}Of(${javaElementClassName}.class);
      <@checkItemLimits model "value" "value_"/>
    }
    else
    {
      throw new BadFormatException("value must be an array not " + node.getClass().getName());
    }
      <#break>
    <#default>
    if(node instanceof I${javaElementClassName}Provider)
    {
      ${javaFieldClassName} value = ${javaConstructTypePrefix}((I${javaElementClassName}Provider)node).as${javaElementClassName}()${javaConstructTypePostfix};
    <#if requiresChecks>
      <@checkLimits "      " model "value"/>
    </#if>
      value_ = ${javaTypeCopyPrefix}value${javaTypeCopyPostfix};
    }
    else
    {
      throw new BadFormatException("value must be an instance of ${javaFieldClassName} not " + node.getClass().getName());
    }
  </#switch>

  }
  
  public ${modelJavaFieldClassName} getValue()
  {
    return value_;
  }
  
  <#if model.enum??>
  // ENUM
    <#list model.enum.values as value>
    // value ${value}
    </#list>
  </#if>
  
  public static abstract class Builder
  {
    public abstract ${modelJavaClassName} build(${modelJavaFieldClassName} value)<#if model.canFailValidation> throws BadFormatException</#if>;
    public abstract ${modelJavaClassName} build(IJsonDomNode node) throws BadFormatException;
    public abstract ${modelJavaFieldClassName} to${modelJavaFieldClassName}(${modelJavaClassName} instance);
  }
<#assign subTemplateName="${.current_template_name!''}"><#include "S2-japigen-template-java-SubEpilogue.ftl">
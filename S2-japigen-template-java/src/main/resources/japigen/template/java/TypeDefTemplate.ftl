<#assign subTemplateName="${.current_template_name!''}"><#include "S2-japigen-template-java-SubPrologue.ftl">
import javax.annotation.Nonnull;
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

import com.symphony.s2.japigen.runtime.Model${modelJavaFieldClassName}TypeBuilder;
import ${javaFacadePackage}.${modelJavaClassName};

<#include "TypeDefHeader.ftl">
<@setJavaType model/>
@Immutable
public class ${modelJavaClassName}ModelType<#if isComparable(model)> implements Comparable<${modelJavaClassName}ModelType></#if>
{
  private @Nonnull ${modelJavaFieldClassName} value_;

  protected ${modelJavaClassName}ModelType(@Nonnull ${modelJavaFieldClassName} value) throws BadFormatException
  {
    if(value == null)
      throw new BadFormatException("value is required.");
      
<@checkLimits "    " model "value"/>
    value_ = value;
  }

  <#-- Constructor from Json   -->  
  protected ${modelJavaClassName}ModelType(@Nonnull IJsonDomNode node) throws BadFormatException
  {
    if(node == null)
      throw new BadFormatException("value is required.");
      
  <#switch model.elementType>
    <#case "Ref">
    value_ = ${javaConstructTypePrefix}node${javaConstructTypePostfix};
      <#break>
      
    <#case "Array">
    I dont think this can ever be
    if(node instanceof JsonArray)
    {
      value_ = ((JsonArray<?>)node).asImmutable${javaCardinality}Of(${javaElementClassName}.class);
<@checkItemLimits "      " model "value" "value_"/>
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
  
  public @Nonnull ${modelJavaFieldClassName} getValue()
  {
    return value_;
  }
  
  @Override
  public String toString()
  {
    return value_.toString();
  }

  @Override
  public int hashCode()
  {
    return value_.hashCode();
  }

  @Override
  public boolean equals(Object obj)
  {
    if(obj instanceof ${modelJavaClassName}ModelType)
    {
      return value_.equals(((${modelJavaClassName}ModelType)obj).value_);
    }
    
    return false;
  }

  <#if isComparable(model)>  
  @Override
  public int compareTo(${modelJavaClassName}ModelType other)
  {
    return value_.compareTo(other.value_);
  }
  </#if>
  
  <#if model.enum??>
  // ENUM
    <#list model.enum.values as value>
    // value ${value}
    </#list>
  </#if>
  
  public static abstract class Builder extends Model${modelJavaFieldClassName}TypeBuilder<${modelJavaClassName}>
  {
  }
<#assign subTemplateName="${.current_template_name!''}"><#include "S2-japigen-template-java-SubEpilogue.ftl">
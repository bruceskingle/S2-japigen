<#include "../S2-japigen-template-java-Prologue.ftl">
import javax.annotation.concurrent.Immutable;

import com.symphony.s2.japigen.runtime.AbstractModelObject;

import org.symphonyoss.s2.common.dom.IBooleanProvider;
import org.symphonyoss.s2.common.dom.IStringProvider;
import org.symphonyoss.s2.common.dom.IIntegerProvider;
import org.symphonyoss.s2.common.dom.ILongProvider;
import org.symphonyoss.s2.common.dom.IFloatProvider;
import org.symphonyoss.s2.common.dom.IDoubleProvider;
import org.symphonyoss.s2.common.dom.IByteStringProvider;
import org.symphonyoss.s2.common.dom.json.IJsonDomNode;
import org.symphonyoss.s2.common.dom.json.ImmutableJsonObject;
import org.symphonyoss.s2.common.dom.json.JsonArray;
import org.symphonyoss.s2.common.dom.json.MutableJsonObject;

import org.symphonyoss.s2.common.exception.BadFormatException;

<@importFieldTypes model true/>

import ${javaFacadePackage}.${model.camelCapitalizedName};

<#include "Object.ftl">
@Immutable
public abstract class ${model.camelCapitalizedName}ModelObject extends AbstractModelObject implements I${model.camelCapitalizedName}ModelObject
{
  private final ${"ImmutableJsonObject"?right_pad(25)}  jsonObject_;
<#list model.children as field>
  <@setJavaType field/>
  private final ${javaType?right_pad(25)}  ${field.camelName}_;
</#list>
  
<#-- Constrictor from fields -->  
  protected ${model.camelCapitalizedName}ModelObject(
<#list model.children as field><@setJavaType field/>
    ${javaType?right_pad(25)} ${field.camelName}<#sep>,
</#list>

  )<@checkLimitsClassThrows model/>
  {
    MutableJsonObject jsonObject = new MutableJsonObject();
<#list model.children as field>
<@setJavaType field/>
<@checkLimits field field.camelName/>
    ${field.camelName}_ = ${javaTypeCopyPrefix}${field.camelName}${javaTypeCopyPostfix};
    jsonObject.${addJsonNode}("${field.camelName}", ${javaGetValuePrefix}${field.camelName}_${javaGetValuePostfix});
</#list>

    jsonObject_ = jsonObject.immutify();
  }
  
<#-- Constrictor from Json   -->  
  protected ${model.camelCapitalizedName}ModelObject(ImmutableJsonObject jsonObject) throws BadFormatException
  {
    jsonObject_ = jsonObject;

<#list model.children as field>
<@setJavaType field/>
    if(jsonObject_.containsKey("${field.camelName}"))
    {
      IJsonDomNode  node = jsonObject_.get("${field.camelName}");
  <#switch field.elementType>
    <#case "Array">
      if(node instanceof JsonArray)
      {
        ${field.camelName}_ = ((JsonArray<?>)node).asImmutable${javaCardinality}Of(${javaBaseType}.class);
        <@checkItemLimits field field.camelName "${field.camelName}_"/>
      }
      else
      {
        throw new BadFormatException("${field.camelName} must be an array not " + node.getClass().getName());
      }
      <#break>
      
    <#default>
      if(node instanceof I${javaRefType}Provider)
      {
        ${javaType} ${field.camelName} = ${javaConstructTypePrefix}((I${javaRefType}Provider)node).as${javaRefType}()${javaConstructTypePostfix};
      <@checkLimits field field.camelName/>
        ${field.camelName}_ = ${javaTypeCopyPrefix}${field.camelName}${javaTypeCopyPostfix};
      }
      else
      {
        throw new BadFormatException("${field.camelName} must be an instance of ${javaRefType} not " + node.getClass().getName());
      }
  </#switch>
    }
    else
    {
  <#if isNotNullable>
      throw new BadFormatException("${field.camelName} is required.");
  <#else>
      ${field.camelName}_ = null;
  </#if>
    }
</#list>
  }

  public ImmutableJsonObject getJsonObject()
  {
    return jsonObject_;
  }
<#list model.children as field>
  <@setJavaType field/>
  
  @Override
  public ${javaType} get${field.camelCapitalizedName}()
  {
    return ${field.camelName}_;
  }
  <#switch field.elementType>
    <#case "OneOf">
      <@setJavaType field/>
      
  public class ${field.camelCapitalizedName}ModelObject
  {
      <#list field.children as ref>
        <#assign subfield=ref.reference>
        <@setJavaType ref/>
    private ${javaType?right_pad(25)}  ${subfield.camelName}_;
      </#list>
  
    public ${field.camelCapitalizedName}ModelObject(
      <#list field.children as ref>
        <#assign subfield=ref.reference>
        <@setJavaType ref/>
      ${javaType?right_pad(25)} ${subfield.camelName}<#sep>,
      </#list>
      
    )
    {
      <#list field.children as ref>
        <#assign subfield=ref.reference>
        <@setJavaType ref/>
        <@checkLimits ref subfield.camelName/>
      ${subfield.camelName}_ = ${javaTypeCopyPrefix}${subfield.camelName}${javaTypeCopyPostfix};
      </#list>
    }
      <#list field.children as ref>
        <#assign subfield=ref.reference>
        <@setJavaType ref/>
        
    public ${javaType} get${subfield.camelCapitalizedName}()
    {
      return ${subfield.camelName}_;
    }
      </#list>
  }
      <#break>
    </#switch>
</#list>
  
  public static abstract class Builder
  {
  <#list model.children as field>
    <@setJavaType field/>
    private ${javaType?right_pad(25)}  ${field.camelName}__${javaBuilderTypeNew};
  </#list>
    
    protected Builder()
    {
    }
    
    protected Builder(Builder initial)
    {
  <#list model.children as field>
  <@setJavaType field/>
      ${field.camelName}__${javaBuilderTypeCopyPrefix}initial.${field.camelName}__${javaBuilderTypeCopyPostfix};
  </#list>
    }
  <#list model.children as field>
    <@setJavaType field/>
    
    public ${javaType} get${field.camelCapitalizedName}()
    {
      return ${field.camelName}__;
    }
    
    public ${model.camelCapitalizedName}.Builder with${field.camelCapitalizedName}(${javaType} ${field.camelName})<@checkLimitsThrows field/>
    {
    <@checkLimits field field.camelName/>
      ${field.camelName}__${javaBuilderTypeCopyPrefix}${field.camelName}${javaBuilderTypeCopyPostfix};
      return (${model.camelCapitalizedName}.Builder)this;
    }
    <#switch field.elementType>
      <#case "Ref">
      <#assign javaSubType=javaType>
      <@setJavaType field.reference/>
    
    public ${model.camelCapitalizedName}.Builder with${field.camelCapitalizedName}(${javaType} ${field.camelName})<@checkLimitsThrows field/>
    {
      ${field.camelName}__ = new ${javaSubType}(${field.camelName});
      return (${model.camelCapitalizedName}.Builder)this;
    }
        <#break>
    </#switch>
  </#list>
    
    public abstract ${model.camelCapitalizedName} build()<@checkLimitsClassThrows model/>;
  }
}
<#include "../S2-japigen-template-java-Epilogue.ftl">
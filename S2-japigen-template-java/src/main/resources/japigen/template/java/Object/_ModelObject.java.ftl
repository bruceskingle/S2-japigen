<#include "../S2-japigen-template-java-Prologue.ftl">
<@setPrologueJavaType model/>
import javax.annotation.concurrent.Immutable;

import com.symphony.s2.japigen.runtime.JapigenRuntime;
import com.symphony.s2.japigen.runtime.ModelObject;

import org.symphonyoss.s2.common.dom.IBooleanProvider;
import org.symphonyoss.s2.common.dom.IStringProvider;
import org.symphonyoss.s2.common.dom.IIntegerProvider;
import org.symphonyoss.s2.common.dom.ILongProvider;
import org.symphonyoss.s2.common.dom.IFloatProvider;
import org.symphonyoss.s2.common.dom.IDoubleProvider;
import org.symphonyoss.s2.common.dom.IByteStringProvider;
import org.symphonyoss.s2.common.dom.json.IJsonDomNode;
import org.symphonyoss.s2.common.dom.json.IImmutableJsonDomNode;
import org.symphonyoss.s2.common.dom.json.ImmutableJsonObject;
import org.symphonyoss.s2.common.dom.json.JsonArray;
import org.symphonyoss.s2.common.dom.json.MutableJsonObject;

import org.symphonyoss.s2.common.exception.BadFormatException;

<@importFieldTypes model true/>

import ${javaFacadePackage}.${modelJavaClassName};

<#include "Object.ftl">
@Immutable
public abstract class ${modelJavaClassName}ModelObject extends ModelObject implements I${modelJavaClassName}ModelObject
{
  public static final String TYPE_ID = "${model.model.japigenId}#/components/schemas/${model.name}";
  
  private final ${"ImmutableJsonObject"?right_pad(25)}  jsonObject_;
<#list model.fields as field>
  <@setJavaType field/>
  <@printField/>
  private final ${javaClassName?right_pad(25)}  ${field.camelName}_;
</#list>
  
<#-- Constructor from fields -->  
  protected ${model.camelCapitalizedName}ModelObject(
<#list model.fields as field><@setJavaType field/>
    ${javaClassName?right_pad(25)} ${field.camelName}<#sep>,
</#list>

  )<@checkLimitsClassThrows model/>
  {
    MutableJsonObject jsonObject = new MutableJsonObject();
    
    jsonObject.addIfNotNull(JapigenRuntime.JSON_TYPE, TYPE_ID);
    
<#list model.fields as field>
<@setJavaType field/>
<@printField/>
<#if requiresChecks>
<@checkLimits field field.camelName/>
</#if>
    ${field.camelName}_ = ${javaTypeCopyPrefix}${field.camelName}${javaTypeCopyPostfix};
    jsonObject.${addJsonNode}("${field.camelName}", ${javaGetValuePrefix}${field.camelName}_${javaGetValuePostfix});
</#list>

    jsonObject_ = jsonObject.immutify();
  }
  
<#-- Constructor from Json   -->  
  protected ${model.camelCapitalizedName}ModelObject(ImmutableJsonObject jsonObject) throws BadFormatException
  {
    jsonObject_ = jsonObject;

    IImmutableJsonDomNode typeNode = jsonObject_.get(JapigenRuntime.JSON_TYPE);
    if(!(typeNode instanceof IStringProvider && TYPE_ID.equals(((IStringProvider)typeNode).asString())))
    {
      throw new BadFormatException("_type attribute must be \"" + TYPE_ID + "\"");
    }
    
<#list model.fields as field>
<@setJavaType field/>
<@printField/>
    if(jsonObject_.containsKey("${field.camelName}"))
    {
      IJsonDomNode  node = jsonObject_.get("${field.camelName}");
  <#switch field.elementType>
    <#case "Ref">
      ${field.camelName}_ = ${javaConstructTypePrefix}node${javaConstructTypePostfix};
      <#break>
      
    <#case "Array">
      if(node instanceof JsonArray)
      {
        ${field.camelName}_ = ((JsonArray<?>)node).asImmutable${javaCardinality}Of(${javaElementClassName}.class);
        <@checkItemLimits field field.camelName "${field.camelName}_"/>
      }
      else
      {
        throw new BadFormatException("${field.camelName} must be an array not " + node.getClass().getName());
      }
      <#break>
      
    <#default>
      if(node instanceof I${javaElementClassName}Provider)
      {
        ${javaFieldClassName} ${field.camelName} = ${javaConstructTypePrefix}((I${javaElementClassName}Provider)node).as${javaElementClassName}()${javaConstructTypePostfix};
      <#if requiresChecks>
        <@checkLimits field field.camelName/>
      </#if>
        ${field.camelName}_ = ${javaTypeCopyPrefix}${field.camelName}${javaTypeCopyPostfix};
      }
      else
      {
        throw new BadFormatException("${field.camelName} must be an instance of ${javaFieldClassName} not " + node.getClass().getName());
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
<#list model.fields as field>
  <@setJavaType field/>
  
  @Override
  public ${javaClassName} get${field.camelCapitalizedName}()
  {
    return ${field.camelName}_;
  }
  <#-------------------------------------
  
  
  
  <#switch field.elementType>
    <#case "OneOf">
      <@setJavaType field/>
      
  public class ${field.camelCapitalizedName}ModelObject
  {
      <#list field.fields as ref>
        <#assign subfield=ref.reference>
        <@setJavaType ref/>
    private ${javaFieldClassName?right_pad(25)}  ${subfield.camelName}_;
      </#list>
  
    public ${field.camelCapitalizedName}ModelObject(
      <#list field.fields as ref>
        <#assign subfield=ref.reference>
        <@setJavaType ref/>
      ${javaFieldClassName?right_pad(25)} ${subfield.camelName}<#sep>,
      </#list>
      
    )
    {
      <#list field.fields as ref>
        <#assign subfield=ref.reference>
        <@setJavaType ref/>
        <@checkLimits ref subfield.camelName/>
      ${subfield.camelName}_ = ${javaTypeCopyPrefix}${subfield.camelName}${javaTypeCopyPostfix};
      </#list>
    }
      <#list field.fields as ref>
        <#assign subfield=ref.reference>
        <@setJavaType ref/>
        
    public ${javaFieldClassName} get${subfield.camelCapitalizedName}()
    {
      return ${subfield.camelName}_;
    }
      </#list>
  }
      <#break>
    </#switch>
    
    is this even called? ------------------------------->
</#list>
  
  public static abstract class Builder
  {
  <#list model.fields as field>
    <@setJavaType field/>
    private ${javaClassName?right_pad(25)}  ${field.camelName}__${javaBuilderTypeNew};
  </#list>
    
    protected Builder()
    {
    }
    
    protected Builder(Builder initial)
    {
  <#list model.fields as field>
  <@setJavaType field/>
      ${field.camelName}__${javaBuilderTypeCopyPrefix}initial.${field.camelName}__${javaBuilderTypeCopyPostfix};
  </#list>
    }
  <#list model.fields as field>
    <@setJavaType field/>
    
    public ${javaClassName} get${field.camelCapitalizedName}()
    {
      return ${field.camelName}__;
    }
    
    public ${model.camelCapitalizedName}.Builder with${field.camelCapitalizedName}(${javaClassName} ${field.camelName})<@checkLimitsThrows field/>
    {
    <@checkLimits field field.camelName/>
      ${field.camelName}__${javaBuilderTypeCopyPrefix}${field.camelName}${javaBuilderTypeCopyPostfix};
      return (${model.camelCapitalizedName}.Builder)this;
    }
    <#switch field.elementType>
      <#case "Ref">

<@printField/>
    public ${model.camelCapitalizedName}.Builder with${field.camelCapitalizedName}(${javaFieldClassName} ${field.camelName})<@checkLimitsThrows field/>
    {
      ${field.camelName}__ = new ${javaClassName}(${field.camelName});
      return (${model.camelCapitalizedName}.Builder)this;
    }
        <#break>
    </#switch>
  </#list>
    
    public abstract ${modelJavaClassName} build()<@checkLimitsClassThrows model/>;
  }
}
<#include "../S2-japigen-template-java-Epilogue.ftl">
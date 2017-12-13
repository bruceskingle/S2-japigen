<#include "ObjectHeader.ftl">

<#list model.fields as field>
  <@setJavaType field/>
  private final ${javaClassName?right_pad(25)}  ${field.camelName}_;
</#list>
<#-- Constructor from fields -->  
  protected ${modelJavaClassName}ModelObject(
    ${(modelJavaClassName + ".Factory")?right_pad(25)} _factory,
<#list model.fields as field><@setJavaType field/>
    ${javaClassName?right_pad(25)} ${field.camelName}<#sep>,
</#list>

  )<@checkLimitsClassThrows model/>
  {
    _factory_ = _factory;
    MutableJsonObject jsonObject = new MutableJsonObject();
    
    jsonObject.addIfNotNull(JapigenRuntime.JSON_TYPE, TYPE_ID);
<#list model.fields as field>
<@setJavaType field/>
<#if requiresChecks>
<@checkLimits "    " field field.camelName/>
</#if>

    ${field.camelName}_ = ${javaTypeCopyPrefix}${field.camelName}${javaTypeCopyPostfix};
    if(${field.camelName}_ != null)
    {
      jsonObject.${addJsonNode}("${field.camelName}", ${javaGetValuePrefix}${field.camelName}_${javaGetValuePostfix});
    }
</#list>

    jsonObject_ = jsonObject.immutify();
    asString_ = SERIALIZER.serialize(jsonObject_);
  }
  
<#-- Constructor from Json   -->  
  protected ${modelJavaClassName}ModelObject(${modelJavaClassName}.Factory _factory, ImmutableJsonObject jsonObject) throws BadFormatException
  {
    _factory_ = _factory;
    jsonObject_ = jsonObject;
    asString_ = SERIALIZER.serialize(jsonObject_);

    IImmutableJsonDomNode typeNode = jsonObject_.get(JapigenRuntime.JSON_TYPE);
    if(!(typeNode instanceof IStringProvider && TYPE_ID.equals(((IStringProvider)typeNode).asString())))
    {
      throw new BadFormatException("_type attribute must be \"" + TYPE_ID + "\"");
    }
    
<#list model.fields as field>
    if(jsonObject_.containsKey("${field.camelName}"))
    {
      IJsonDomNode  node = jsonObject_.get("${field.camelName}");
  <@generateCreateFieldFromJsonDomNode "      " field "${field.camelName}_"/>
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
<#list model.fields as field>
  <@setJavaType field/>
  
  @Override
  public ${javaClassName} get${field.camelCapitalizedName}()
  {
    return ${field.camelName}_;
  }
  <#switch field.elementType>
    <#case "OneOf">
      
  public class ${field.camelCapitalizedName}ModelObject
  {
    private final ${"String"?right_pad(25)}  _discriminator_;
    private final ${"Object"?right_pad(25)}  _payload_;
  
    public ${field.camelCapitalizedName}ModelObject(Object payload) throws BadFormatException
    {
      if(payload == null)
      {
        throw new BadFormatException("OneOf payload cannot be null");
      }
      <#list field.children as ref>
      else if(payload instanceof ${javaClassName})
      {
        <@setJavaType ref/>
        <@checkLimits "        " ref "(${javaClassName})payload"/>
        _payload_ = ${javaTypeCopyPrefix}payload${javaTypeCopyPostfix};
        _discriminator_ = "${ref.name}";
      }
      </#list>
      else
      {
        throw new BadFormatException("Unknown payload type \"" + payload.getClass().getName() + "\"");
      }
    }
    public Object getPayload()
    {
      return _payload_;
    }
    
    public String getDiscriminator()
    {
      return _discriminator_;
    }
  }
      <#break>
    </#switch>
    
</#list>

<#include "ObjectBody.ftl">
  
  public static abstract class Factory extends ModelObjectFactory<${modelJavaClassName}, ${model.model.camelCapitalizedName}Factory>
  {
    private ${model.model.camelCapitalizedName}Factory factory_;
    
    public Factory(${model.model.camelCapitalizedName}Factory modelFactory)
    {
      factory_ = modelFactory;
    }
    
    public ${model.model.camelCapitalizedName}Factory getFactory()
    {
      return factory_;
    }
    
    public static abstract class Builder extends ModelObjectFactory.Builder
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
      
      public ${modelJavaClassName}.Factory.Builder with${field.camelCapitalizedName}(${javaClassName} ${field.camelName})<#if field.canFailValidation> throws BadFormatException</#if>
      {
      <@checkLimits "      " field field.camelName/>
        ${field.camelName}__${javaBuilderTypeCopyPrefix}${field.camelName}${javaBuilderTypeCopyPostfix};
        return (${modelJavaClassName}.Factory.Builder)this;
      }
      <#switch field.elementType>
        <#case "Ref">
          <#switch field.reference.elementType>
            <#case "OneOf">
            <#case "AllOf">
            <#case "Object">
              <#break>
            
            <#default>
      public ${modelJavaClassName}.Factory.Builder with${field.camelCapitalizedName}(${javaFieldClassName} ${field.camelName})<#if isExternal || field.canFailValidation> throws BadFormatException</#if>
      {
        ${field.camelName}__ = ${javaConstructTypePrefix}${field.camelName}${javaConstructTypePostfix};
        return (${modelJavaClassName}.Factory.Builder)this;
      }
              <#break>
          </#switch>
          <#break>
      </#switch>
    </#list>
      
      public abstract ${modelJavaClassName} build()<@checkLimitsClassThrows model/>;
    }
  }
  
  <#list model.children as field>
    <#if field.isAnonymousInnerClass>
      // AnonymousInnerClass ${field.name}
    </#if>
  </#list>
}
<#include "../S2-japigen-template-java-Epilogue.ftl">
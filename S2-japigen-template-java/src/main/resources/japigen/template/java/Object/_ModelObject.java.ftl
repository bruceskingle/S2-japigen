<#include "ObjectHeader.ftl">

<#list model.fields as field>
  <@setJavaType field/>
  private final ${javaClassName?right_pad(25)}  ${field.camelName}_;
</#list>

<#-- Constructor from fields -->  
  protected ${modelJavaClassName}ModelObject(${modelJavaClassName}.Factory _factory, I${model.camelCapitalizedName} _other)<@checkLimitsClassThrows model/>
  {
    super(_other.getJsonObject());
    
    _factory_ = _factory;
<#list model.fields as field>
    <@setJavaType field/>

    ${field.camelName}_ = ${javaTypeCopyPrefix}_other.get${field.camelCapitalizedName}()${javaTypeCopyPostfix};
<#if requiresChecks>
<@checkLimits "    " field field.camelName + "_"/>
</#if>

</#list>
  }
  
<#-- Constructor from Json   -->  
  protected ${modelJavaClassName}ModelObject(${modelJavaClassName}.Factory _factory, ImmutableJsonObject _jsonObject) throws BadFormatException
  {
    super(_jsonObject);
    
    if(_jsonObject == null)
      throw new BadFormatException("_jsonObject is required");
  
    _factory_ = _factory;

    IImmutableJsonDomNode typeNode = _jsonObject.get(JapigenRuntime.JSON_TYPE);
    if(!(typeNode instanceof IStringProvider && TYPE_ID.equals(((IStringProvider)typeNode).asString())))
    {
      throw new BadFormatException("_type attribute must be \"" + TYPE_ID + "\"");
    }
    
<#list model.fields as field>
    if(_jsonObject.containsKey("${field.camelName}"))
    {
      IJsonDomNode  node = _jsonObject.get("${field.camelName}");
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
  
  public static abstract class Factory extends ModelObjectFactory<${modelJavaClassName}, I${model.model.camelCapitalizedName}>
  {
    private I${model.model.camelCapitalizedName} model_;
    
    public Factory(I${model.model.camelCapitalizedName} model)
    {
      model_ = model;
    }
    
    @Override
    public I${model.model.camelCapitalizedName} getModel()
    {
      return model_;
    }
    
    public static abstract class Builder extends ModelObjectFactory.Builder implements I${modelJavaClassName}
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
      <@checkLimits "        " field field.camelName/>
        ${field.camelName}__${javaBuilderTypeCopyPrefix}${field.camelName}${javaBuilderTypeCopyPostfix};
        return (${modelJavaClassName}.Factory.Builder)this;
      }
      <#if field.isTypeDef>

      public ${modelJavaClassName}.Factory.Builder with${field.camelCapitalizedName}(${javaFieldClassName} ${field.camelName}) throws BadFormatException
      {
      <#if field.elementType=="Field" && field.required>
        if(${field.camelName} == null)
          throw new BadFormatException("${field.camelName} is required.");

      </#if>
        ${field.camelName}__ = ${javaConstructTypePrefix}${field.camelName}${javaConstructTypePostfix};
        return (${modelJavaClassName}.Factory.Builder)this;
      }
      </#if>
    </#list>
    
      @Override 
      public ImmutableJsonObject getJsonObject()
      {
        MutableJsonObject jsonObject = new MutableJsonObject();
        
        jsonObject.addIfNotNull(JapigenRuntime.JSON_TYPE, TYPE_ID);
    <#list model.fields as field>
    <@setJavaType field/>
    
        if(${field.camelName}__ != null)
        {
          jsonObject.${addJsonNode}("${field.camelName}", ${javaGetValuePrefix}${field.camelName}__${javaGetValuePostfix});
        }
    </#list>
    
        return jsonObject.immutify();
      }
          
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
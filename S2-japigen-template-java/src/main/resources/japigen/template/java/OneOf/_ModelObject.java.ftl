<#include "../Object/ObjectHeader.ftl">

  private final ${"String"?right_pad(25)}  _discriminator_;
  private final ${"Object"?right_pad(25)}  _payload_;
  
  protected ${modelJavaClassName}ModelObject(${modelJavaClassName}.Factory _factory, Object payload) throws BadFormatException
  {
    _factory_ = _factory;
    MutableJsonObject jsonObject = new MutableJsonObject();
    
    jsonObject.addIfNotNull(JapigenRuntime.JSON_TYPE, TYPE_ID);

    if(payload == null)
    {
      throw new BadFormatException("OneOf payload cannot be null");
    }
<#list model.fields as field><@setJavaType field/>
    else if(payload instanceof ${javaClassName})
    {
<#if requiresChecks>
<@checkLimits "      " field "(${javaClassName})payload"/>
</#if>
      _payload_ = ${javaTypeCopyPrefix}payload${javaTypeCopyPostfix};

<#if field.elementType=="Ref">
  <#assign elementType=field.reference.elementType>
<#else>
  <#assign elementType=field.elementType>
</#if>
<#switch elementType>
  <#case "Object">
  <#case "OneOf">
  <#case "AllOf">
      Iterator<String> it = ((${javaClassName})payload).getJsonObject().getNameIterator();
      
      while(it.hasNext())
      {
        String name = it.next();
        
        jsonObject.addIfNotNull(name, ((${javaClassName})payload).getJsonObject().get(name));
      }
      <#break>
        
    <#default>
      jsonObject.addIfNotNull("${field.camelName}", ((${javaClassName})payload).getValue());
</#switch>

      _discriminator_ = "${field.name}";
      jsonObject.addIfNotNull("${model.discriminator.name}", "${field.name}");
    }
</#list>
    else
    {
      throw new BadFormatException("Unknown payload type \"" + payload.getClass().getName() + "\"");
    }
    jsonObject_ = jsonObject.immutify();
    asString_ = SERIALIZER.serialize(jsonObject_);
  }
  
<#-- Constructor from Json   -->  
  protected ${modelJavaClassName}ModelObject(${modelJavaClassName}.Factory _factory, ImmutableJsonObject node) throws BadFormatException
  {
    _factory_ = _factory;
    jsonObject_ = node;
    asString_ = SERIALIZER.serialize(jsonObject_);

    IImmutableJsonDomNode typeNode = jsonObject_.get(JapigenRuntime.JSON_TYPE);
    if(!(typeNode instanceof IStringProvider && TYPE_ID.equals(((IStringProvider)typeNode).asString())))
    {
      throw new BadFormatException("_type attribute must be \"" + TYPE_ID + "\"");
    }
    
    IImmutableJsonDomNode discriminatorNode = jsonObject_.get("${model.discriminator.name}");
    if(discriminatorNode instanceof IStringProvider)
    {
      _discriminator_ = ((IStringProvider)discriminatorNode).asString();
    }
    else
    {
      throw new BadFormatException("discriminator attribute \"${model.discriminator.name}\" must be \"" + TYPE_ID + "\"");
    }
    
    switch(_discriminator_)
    {
<#list model.fields as field>
      case "${field.camelName}":
        <@generateCreateFieldFromJsonDomNode "        " field "_payload_"/>
        break;
        
</#list>
      default:
        throw new BadFormatException("Invalid discriminator value \"" + _discriminator_ + "\"");
    }
  }
  
  @Override
  public Object getPayload()
  {
    return _payload_;
  }
  
  @Override
  public String getDiscriminator()
  {
    return _discriminator_;
  }
  
  <#include "../Object/ObjectBody.ftl">
  
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
      private  ${"Object"?right_pad(25)}  _payload__;
      
      protected Builder()
      {
      }
      
      protected Builder(Builder initial)
      {
        _payload__        = initial._payload__;
      }
      
      public Object getPayload()
      {
        return _payload__;
      }
    <#list model.fields as field>
      <@setJavaType field/>
      
      <@printField/>
      public ${modelJavaClassName}.Factory.Builder with${field.camelCapitalizedName}(${javaClassName} ${field.camelName})<#if field.canFailValidation> throws BadFormatException</#if>
      {
      <@checkLimits "        " field field.camelName/>
        _payload__${javaBuilderTypeCopyPrefix}${field.camelName}${javaBuilderTypeCopyPostfix};
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
            
      public ${modelJavaClassName}.Factory.Builder with${field.camelCapitalizedName}(${javaFieldClassName} ${field.camelName})<#if field.canFailValidation> throws BadFormatException</#if>
      {
        _payload__ = new ${javaClassName}(${field.camelName});
        return (${modelJavaClassName}.Factory.Builder)this;
      }
              <#break>
          </#switch>
          <#break>
      </#switch>
    </#list>
      
      public abstract ${modelJavaClassName} build() throws BadFormatException;
    }
  }
  
  <#list model.children as field>
    <#if field.isAnonymousInnerClass>
      // AnonymousInnerClass ${field.name}
    </#if>
  </#list>
}
<#include "../S2-japigen-template-java-Epilogue.ftl">
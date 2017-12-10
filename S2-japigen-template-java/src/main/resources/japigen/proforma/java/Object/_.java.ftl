<#include "../S2-japigen-proforma-java-Prologue.ftl">
<@setPrologueJavaType model/>
import javax.annotation.concurrent.Immutable;

import com.google.protobuf.ByteString;

import org.symphonyoss.s2.common.dom.json.ImmutableJsonObject;

import org.symphonyoss.s2.common.exception.BadFormatException;

<@importFieldTypes model false/>

import ${javaGenPackage}.${model.camelCapitalizedName}ModelObject;
import ${javaGenPackage}.${model.model.camelCapitalizedName}ModelFactory;

<@setJavaType model/>
<#include "../../../template/java/Object/Object.ftl">
@Immutable
public class ${model.camelCapitalizedName} extends ${model.camelCapitalizedName}ModelObject implements I${model.camelCapitalizedName}
{
<#-- Constrictor from fields -->  
  private ${model.camelCapitalizedName}(
<#list model.fields as field><@setJavaType field/>
    ${javaClassName?right_pad(25)} ${field.camelName}<#sep>,
</#list>

  )<@checkLimitsClassThrows model/>
  {
    super(
<#list model.fields as field>
<@setJavaType field/>
      ${field.camelName}<#sep>, 
</#list>

    );
  }
<#--     list model.fields as field>
  <@setJavaType field/>
  <#switch field.elementType>
    <#case "OneOf">
      <@setJavaType field/>
    THIS IS NEVER CALLED I THINK  
  public class ${field.camelCapitalizedName} extends ${field.camelCapitalizedName}ModelObject
  {
    public ${field.camelCapitalizedName}(
      <#list field.fields as ref>
        <#assign subfield=ref.reference>
        <@setJavaType ref/>
      ${javaClassName?right_pad(25)} ${subfield.camelName}<#sep>,
      </#list>
      
    )<@checkLimitsClassThrows model/>
    {
      super(
      <#list field.fields as ref>
        <#assign subfield=ref.reference>
        ${subfield.camelName}<#sep>,
      </#list>
      );
    }
  }
      <#break>
    </#switch>
</#list   -->
  
<#-- Constrictor from Json   -->

  private ${model.camelCapitalizedName}(ImmutableJsonObject jsonObject) throws BadFormatException
  {
    super(jsonObject);
  }
  
  public static class Factory extends ${model.camelCapitalizedName}ModelObject.Factory
  {
    public Factory(${model.model.camelCapitalizedName}ModelFactory modelFactory)
    {
      super(modelFactory);
    }
    
    @Override
    public ${model.camelCapitalizedName} newInstance(ImmutableJsonObject jsonObject) throws BadFormatException
    {
      return new ${model.camelCapitalizedName}(jsonObject);
    }
    
    /**
     * Create a new builder with all fields initialized to default values.
     * 
     * @return A new builder.
     */
    public Builder newBuilder()
    {
      return new Builder();
    }
    
    /**
     * Create a new builder with all fields initialized from the given builder.
     * Values are copied so that subsequent changes to initial will not be reflected in
     * the returned builder.
     * 
     * @param initial A builder whose values are copied into a new builder.
     * 
     * @return A new builder.
     */
    public Builder newBuilder(Builder initial)
    {
      return new Builder(initial);
    }
  
  
    public static class Builder extends ${model.camelCapitalizedName}ModelObject.Factory.Builder
    {
      private Builder()
      {
      }
      
      private Builder(Builder initial)
      {
        super(initial);
      }
    
      @Override
      public ${model.camelCapitalizedName} build()<@checkLimitsClassThrows model/>
      {
        /*
         * This is where you would place hand written code to enforce further constraints
         * on the values of fields in the object, such as constraints across multiple fields.
         */
         
        return new ${model.camelCapitalizedName}(
    <#list model.fields as field>
      <@setJavaType field/>
          get${field.camelCapitalizedName}()<#sep>, 
    </#list>
    
        );
      }
    }
  }
}
<#include "../S2-japigen-proforma-java-Epilogue.ftl">
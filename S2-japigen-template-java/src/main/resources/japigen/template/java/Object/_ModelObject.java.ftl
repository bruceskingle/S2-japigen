<#include "../S2-japigen-template-java-Prologue.ftl">
import javax.annotation.concurrent.Immutable;

<@importFieldTypes model true/>

import ${javaFacadePackage}.${model.camelCapitalizedName};

<#include "Object.ftl">
@Immutable
public abstract class ${model.camelCapitalizedName}ModelObject implements I${model.camelCapitalizedName}ModelObject
{
<#list model.children as field>
  <@setJavaType field/>
  private final ${javaType?right_pad(25)}  ${field.camelName}_;
</#list>
  
  protected ${model.camelCapitalizedName}ModelObject(
<#list model.children as field><@setJavaType field/>
    ${javaType?right_pad(25)} ${field.camelName}<#sep>,
</#list>

  )
  {
<#list model.children as field>
<@setJavaType field/>
<@checkLimits field field.camelName/>
    ${field.camelName}_ = ${javaTypeCopyPrefix}${field.camelName}${javaTypeCopyPostfix};
</#list>
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
    
    public ${model.camelCapitalizedName}.Builder with${field.camelCapitalizedName}(${javaType} ${field.camelName})
    {
    <@checkLimits field field.camelName/>
      ${field.camelName}__ = ${javaTypeCopyPrefix}${field.camelName}${javaTypeCopyPostfix};
      return (${model.camelCapitalizedName}.Builder)this;
    }
    <#switch field.elementType>
      <#case "Ref">
      <#assign javaSubType=javaType>
      <@setJavaType field.reference/>
    
    public ${model.camelCapitalizedName}.Builder with${field.camelCapitalizedName}(${javaType} ${field.camelName})
    {
      ${field.camelName}__ = new ${javaSubType}(${field.camelName});
      return (${model.camelCapitalizedName}.Builder)this;
    }
        <#break>
    </#switch>
  </#list>
    
    public abstract ${model.camelCapitalizedName} build();
  }
}
<#include "../S2-japigen-template-java-Epilogue.ftl">
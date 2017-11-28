<#include "../S2-japigen-template-java-Prologue.ftl">
import javax.annotation.concurrent.Immutable;

<@importFieldTypes model/>
import ${javaFacadePackage}.${model.camelCapitalizedName};
import ${javaFacadePackage}.${model.camelCapitalizedName}.Builder;

<#include "Object.ftl">
@Immutable
public abstract class ${model.camelCapitalizedName}ModelObject
{
<#list model.children as field>
  <@setJavaType field/>
  private final ${javaType?right_pad(25)}  ${field.camelName}_;
</#list>
  
  public ${model.camelCapitalizedName}ModelObject(
<#list model.children as field><@setJavaType field/>
    ${javaType?right_pad(25)} ${field.camelName}<#sep>,
</#list>

  )
  {
<#list model.children as field>
<@setJavaType field/>
<@checkLimits field field.camelName/>
    ${field.camelName}_ = ${javaTypeAssignPrefix}${field.camelName}${javaTypeAssignPostfix};
</#list>
  }
<#list model.children as field>
  <@setJavaType field/>
  
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
      ${subfield.camelName}_ = ${javaTypeAssignPrefix}${subfield.camelName}${javaTypeAssignPostfix};
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
  
  public static abstract class ModelObjectBuilder
  {
<#list model.children as field>
  <@setJavaType field/>
    private ${javaType?right_pad(25)}  ${field.camelName}__;
</#list>
<#list model.children as field>
<@setJavaType field/>
    
    public Builder with${field.camelCapitalizedName}(${javaType} ${field.camelName})
    {
<@checkLimits field field.camelName/>
      ${field.camelName}__ = ${javaTypeAssignPrefix}${field.camelName}${javaTypeAssignPostfix};
      return (Builder)this;
    }
  <#switch field.elementType>
    <#case "Ref">
    <#assign javaSubType=javaType>
    <@setJavaType field.reference/>
    
    public Builder with${field.camelCapitalizedName}(${javaType} ${field.camelName})
    {
      ${field.camelName}__ = new ${javaSubType}(${field.camelName});
      return (Builder)this;
    }
      <#break>
  </#switch>
</#list>

    public ${model.camelCapitalizedName} build()
    {
      return new ${model.camelCapitalizedName}(
<#list model.children as field>
<@setJavaType field/>
        ${field.camelName}__<#sep>, 
</#list>

      );
  }
  }
}
<#include "../S2-japigen-template-java-Epilogue.ftl">
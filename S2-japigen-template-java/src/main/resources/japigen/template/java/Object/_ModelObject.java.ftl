<#include "../S2-japigen-template-java-Prologue.ftl">
<#include "Object.ftl">
<@importFieldTypes model/>

public class ${model.camelCapitalizedName}ModelObject
{
<#list model.children as field>
  <@setJavaType field/>
  private ${javaType?right_pad(25)}  ${field.camelName}_;
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
}
<#include "../S2-japigen-template-java-Epilogue.ftl">
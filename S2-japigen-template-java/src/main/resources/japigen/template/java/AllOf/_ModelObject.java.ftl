<#include "../S2-japigen-template-java-Prologue.ftl">
<#include "AllOf.ftl">
<@importFieldTypes model/>

public class ${model.camelCapitalizedName}ModelObject
{
<#list model.fields as ref>
  <#assign field=ref.reference>
  // ref is ${ref}
  // field is ${field}
  <@setJavaType ref/>
  private ${javaType?right_pad(25)}  ${field.camelName}_;
</#list>
  
  public ${model.camelCapitalizedName}ModelObject(
<#list model.fields as ref>
  <#assign field=ref.reference>
  <@setJavaType ref/>
    ${javaType?right_pad(25)} ${field.camelName}<#sep>,
</#list>

  )
  {
<#list model.fields as ref>
  <#assign field=ref.reference>
  <@setJavaType ref/>
  <@checkLimits ref field.camelName/>
    ${field.camelName}_ = ${javaTypeAssignPrefix}${field.camelName}${javaTypeAssignPostfix};
</#list>
  }
<#list model.fields as ref>
  <#assign field=ref.reference>
  <@setJavaType ref/>
  
  public ${javaType} get${field.camelCapitalizedName}()
  {
    return ${field.camelName}_;
  }
</#list>
}
<#include "../S2-japigen-template-java-Epilogue.ftl">
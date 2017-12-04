<#include "../S2-japigen-template-java-Prologue.ftl">
<#include "AllOf.ftl">
<@importFieldTypes model true/>

public class ${model.camelCapitalizedName}ModelObject
{
<#list model.fields as field>
  <@setJavaType field/>
  private ${javaType?right_pad(25)}  ${field.camelName}_;
</#list>
  
  public ${model.camelCapitalizedName}ModelObject(
<#list model.fields as field>
  <@setJavaType field/>
    ${javaType?right_pad(25)} ${field.camelName}<#sep>,
</#list>

  )
  {
<#list model.fields as field>
  <@setJavaType field/>
  <@checkLimits field field.camelName/>
    ${field.camelName}_ = ${javaTypeCopyPrefix}${field.camelName}${javaTypeCopyPostfix};
</#list>
  }
<#list model.fields as field>
  <@setJavaType field/>
  
  public ${javaType} get${field.camelCapitalizedName}()
  {
    return ${field.camelName}_;
  }
</#list>
}
<#include "../S2-japigen-template-java-Epilogue.ftl">
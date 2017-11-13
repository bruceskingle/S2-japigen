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
</#list>
}
<#include "../S2-japigen-template-java-Epilogue.ftl">
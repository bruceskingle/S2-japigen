<#include "../S2-japigen-template-java-Prologue.ftl">
<#include "../../../template/java/Object/Object.ftl">
<@importFieldTypes model/>

import ${javaGenPackage}.${model.camelCapitalizedName}ModelObject;

<@setJavaType model/>

public class ${model.camelCapitalizedName} extends ${model.camelCapitalizedName}ModelObject
{
  public ${model.camelCapitalizedName}(
<#list model.children as field><@setJavaType field/>
    ${javaType?right_pad(25)} ${field.camelName}<#sep>,
</#list>

  )
  {
    super(
<#list model.children as field>
<@setJavaType field/>
      ${field.camelName}<#sep>, 
</#list>

    );
  }
}
<#include "../S2-japigen-template-java-Epilogue.ftl">
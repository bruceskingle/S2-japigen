<#include "../S2-japigen-template-java-Prologue.ftl">
<@importFieldTypes model/>

import ${javaGenPackage}.${model.camelCapitalizedName}ModelObject;

<#include "../../../template/java/AllOf/AllOf.ftl">
public class ${model.camelCapitalizedName} extends ${model.camelCapitalizedName}ModelObject
{
  public ${model.camelCapitalizedName}(
<#list model.fields as ref>
  <#assign field=ref.reference>
  <@setJavaType ref/>
    ${javaType?right_pad(25)} ${field.camelName}<#sep>,
</#list>

  )
  {
    super(
<#list model.fields as ref>
  <#assign field=ref.reference>
  <@setJavaType ref/>
  <@checkLimits ref field.camelName/>
      ${field.camelName}<#sep>,
</#list>

    );
  }
}
<#include "../S2-japigen-template-java-Epilogue.ftl">
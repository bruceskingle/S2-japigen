<#include "../S2-japigen-proforma-java-Prologue.ftl">
import org.symphonyoss.s2.common.exception.BadFormatException;

<@importFieldTypes model false/>

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

  )<@checkLimitsAllOfThrows model/>
  {
    super(
<#list model.fields as ref>
  <#assign field=ref.reference>
  <@setJavaType ref/>
      ${field.camelName}<#sep>,
</#list>

    );
  }
}
<#include "../S2-japigen-proforma-java-Epilogue.ftl">
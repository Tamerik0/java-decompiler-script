import groovy.lang.MetaClass;
import java.lang.ref.SoftReference;
import org.codehaus.groovy.reflection.ClassInfo;
import org.codehaus.groovy.runtime.GStringImpl;
import org.codehaus.groovy.runtime.ScriptBytecodeAdapter;
import org.codehaus.groovy.runtime.callsite.CallSite;
import org.codehaus.groovy.runtime.callsite.CallSiteArray;
import org.gradle.api.internal.project.ProjectScript;
import org.gradle.jvm.toolchain.JavaLanguageVersion;

public class _BuildScript_ extends ProjectScript {
   // $FF: synthetic field
   private static ClassInfo $staticClassInfo;
   // $FF: synthetic field
   public static transient boolean __$stMC;
   // $FF: synthetic field
   private static SoftReference $callSiteArray;

   public _BuildScript_() {
      CallSite[] var1 = $getCallSiteArray();
      super();
   }

   public Object run() {
      CallSite[] var1 = $getCallSiteArray();
      var1[0].callCurrent(this, ScriptBytecodeAdapter.createMap(new Object[]{"plugin", "java"}));
      Object var2 = var1[1].call(JavaLanguageVersion.class, 17);
      ScriptBytecodeAdapter.setProperty(var2, (Class)null, var1[2].callGetProperty(var1[3].callGroovyObjectGetProperty(this)), "languageVersion");
      var1[4].callCurrent(this, new _BuildScript_$_run_closure1(this, this));
      GStringImpl var3 = new GStringImpl(new Object[]{var1[5].callGroovyObjectGetProperty(this)}, new String[]{"", ""});
      ScriptBytecodeAdapter.setGroovyObjectProperty(var3, _BuildScript_.class, this, "version");
      String var4 = "tamermod";
      ScriptBytecodeAdapter.setGroovyObjectProperty(var4, _BuildScript_.class, this, "group");
      String var5 = "Tamermod";
      ScriptBytecodeAdapter.setGroovyObjectProperty(var5, _BuildScript_.class, this, "archivesBaseName");
      var1[6].callCurrent(this, new _BuildScript_$_run_closure2(this, this));
      var1[7].callCurrent(this, new _BuildScript_$_run_closure3(this, this));
      return var1[8].callCurrent(this, new _BuildScript_$_run_closure4(this, this));
   }

   // $FF: synthetic method
   protected MetaClass $getStaticMetaClass() {
      if (this.getClass() != _BuildScript_.class) {
         return ScriptBytecodeAdapter.initMetaClass(this);
      } else {
         ClassInfo var1 = $staticClassInfo;
         if (var1 == null) {
            $staticClassInfo = var1 = ClassInfo.getClassInfo(this.getClass());
         }

         return var1.getMetaClass();
      }
   }

   // $FF: synthetic method
   private static void $createCallSiteArray_1(String[] var0) {
      var0[0] = "apply";
      var0[1] = "of";
      var0[2] = "toolchain";
      var0[3] = "java";
      var0[4] = "loom";
      var0[5] = "mod_version";
      var0[6] = "repositories";
      var0[7] = "dependencies";
      var0[8] = "processResources";
   }

   // $FF: synthetic method
   private static CallSiteArray $createCallSiteArray() {
      String[] var0 = new String[9];
      $createCallSiteArray_1(var0);
      return new CallSiteArray(_BuildScript_.class, var0);
   }

   // $FF: synthetic method
   private static CallSite[] $getCallSiteArray() {
      CallSiteArray var0;
      if ($callSiteArray == null || (var0 = (CallSiteArray)$callSiteArray.get()) == null) {
         var0 = $createCallSiteArray();
         $callSiteArray = new SoftReference(var0);
      }

      return var0.array;
   }
}

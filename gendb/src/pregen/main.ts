import {craw} from "./craw/craw";
import {normalize} from "./normalize/normalize";

const args = process.argv.slice(2);
const workArg = args.find(arg => arg.startsWith("--work="));

if (workArg) {
    const workValue = workArg.split("=")[1];
    if (workValue === "craw") {
        await craw();
    } else if (workValue === "normalize") {
        await normalize();
    } else {
        console.error("Invalid value for --work. Allowed values: craw, toylabel.");
        process.exit(1);
    }
} else {
    console.error("Missing --work argument.");
    process.exit(1);
}

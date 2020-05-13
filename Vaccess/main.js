
Parse.Cloud.define("pushsample", (request) => {

    return Parse.Push.send({
        channels: ["News"],
        data: {
            title: "Hello from the Cloud Code",
            alert: "Back4App rocks!",
        
        }
        
    }, { useMasterKey: true });

});


Parse.Cloud.define('sendPushToYourself', (request) => {
    let userId = request.user.id;

    let query = new Parse.Query(Parse.Installation);
    query.equalTo("userId", userId);
    query.descending("updatedAt");
    return Parse.Push.send({
        where: query,
        data: {
            title: "Hello from the Cloud Code",
            alert: "Back4App rocks! Single Message!",
        }
    }, { useMasterKey: true });
});

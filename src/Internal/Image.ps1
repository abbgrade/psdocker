class Image {
    [string] $Repository
    [string] $Tag
    [string] $Id
    [string] $CreatedAt
    [string] $Size

    Image() {
        $this | Add-Member -Name Image -MemberType ScriptProperty -Value {
            return "$( $this.Repository ):$( $this.Tag )"
        }
    }
}

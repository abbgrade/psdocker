class Image {
    [string] $Repository
    [string] $Tag
    [string] $Id
    [string] $CreatedAt
    [string] $Size

    Image() {
        $this | Add-Member -Name ImageName -MemberType ScriptProperty -Value {
            if ( $this.Tag ) {
                return "$( $this.Repository ):$( $this.Tag )"
            } else {
                return "$( $this.Repository )"
            }
        }
    }
}

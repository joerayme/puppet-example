<?php
if (file_exists('/data/config/example.com-settings.ini')) {
    $settings = parse_ini_file('/data/config/example.com-settings.ini');
} else {
    $settings = array();
}
?><!DOCTYPE html>
<html>
    <head>
        <title>Example PHP page</title>
        <link rel="stylesheet" type="text/css" href="/bootstrap/css/bootstrap.min.css"/>
    </head>
    <body>
        <div class="container">
            <div class="span12">
                <h1>This is an example PHP application</h1>
                <p>It was written to demonstrate how you'd set up a LAMP stack using puppet.</p>
                <?php if (function_exists('mysql_connect')):?><div class="alert alert-success"><i class="icon-ok-sign"></i> php5-mysql is installed</div><?php endif;?>
                <h2>Managed settings.ini</h2>
                <?php if (!empty($settings)):?>
                <p>The settings file contains the following settings:</p>
                <table class="table table-striped table-bordered">
                    <thead>
                        <tr>
                            <th>Setting name</th>
                            <th>Setting value</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php foreach ($settings as $k => $v):?>
                        <tr>
                            <td><?= $k ?></td>
                            <td><?= $v ?></td>
                        </tr>
                        <?php endforeach;?>
                    </tbody>
                </table>
                <?php else:?>
                <div class="alert alert-error">The settings file was empty</div>
                <?php endif;?>
            </div>
        </div>
    </body>
</html>
---
name: wordpress-migration
description: WordPress migration specialist. Use when user asks about migrating WordPress, moving sites, cloning, or transferring between hosts.
---

# WordPress Migration

## When to use
- User asks to migrate WordPress to a new host
- User asks about moving WordPress to a new domain
- User asks about cloning a WordPress site
- User asks about restoring from backup
- User asks about SSL certificate migration
- User asks about local to production migration

## Migration Methods

### Manual Migration Steps

1. Backup current site
2. Export database
3. Download all files
4. Upload to new server
5. Import database
6. Update URLs in database
7. Update wp-config.php
8. Test and verify

### Duplicator Plugin

```php
// Create installer.php and package.zip
// Upload both to new server
// Run installer wizard
```

### WP-CLI Migration

```bash
# Export database
wp db export backup.sql

# Search and replace URLs
wp search-replace 'https://old-site.com' 'https://new-site.com' --export=backup.sql

# Import database
wp db import backup.sql

# Reset transients
wp transient delete --all

# Flush rewrite rules
wp rewrite flush
```

## Backup Creation

### Database Backup

```php
// Manual backup using mysqldump
// mysqldump -u username -p database_name > backup.sql

// PHP backup script
function backup_database($host, $user, $pass, $name, $tables = '*') {
    $link = mysqli_connect($host, $user, $pass, $name);
    mysqli_select_db($link, $name);
    
    $return = "-- Database: {$name}\n\n";
    
    if ($tables == '*') {
        $tables = [];
        $result = mysqli_query($link, 'SHOW TABLES');
        while ($row = mysqli_fetch_row($result)) {
            $tables[] = $row[0];
        }
    } else {
        $tables = is_array($tables) ? $tables : explode(',', $tables);
    }
    
    foreach ($tables as $table) {
        $result = mysqli_query($link, 'SELECT * FROM ' . $table);
        $num_fields = mysqli_num_fields($result);
        
        $return .= "DROP TABLE IF EXISTS {$table};";
        $row2 = mysqli_fetch_row(mysqli_query($link, 'SHOW CREATE TABLE ' . $table));
        $return .= "\n\n" . $row2[1] . ";\n\n";
        
        while ($row = mysqli_fetch_row($result)) {
            $return .= 'INSERT INTO ' . $table . ' VALUES(';
            for ($j = 0; $j < $num_fields; $j++) {
                $row[$j] = addslashes($row[$j]);
                $return .= isset($row[$j]) ? '"' . $row[$j] . '"' : '""';
                $return .= $j < ($num_fields - 1) ? ',' : '';
            }
            $return .= ");\n";
        }
        $return .= "\n\n";
    }
    
    return $return;
}

// Usage
$backup = backup_database(DB_HOST, DB_USER, DB_PASSWORD, DB_NAME);
file_put_contents('backup_' . date('Y-m-d') . '.sql', $backup);
```

### Complete Site Backup

```php
function backup_site_files($source, $destination) {
    $zip = new ZipArchive();
    
    if ($zip->open($destination, ZipArchive::CREATE | ZipArchive::OVERWRITE) === true) {
        $source = realpath($source);
        
        $files = new RecursiveIteratorIterator(
            new RecursiveDirectoryIterator($source),
            RecursiveIteratorIterator::SELF
        );
        
        foreach ($files as $file) {
            $file = realpath($file);
            
            if (is_dir($file)) {
                $zip->addEmptyDir(str_replace($source . '/', '', $file . '/'));
            } else if (is_file($file)) {
                $zip->addFromString(
                    str_replace($source . '/', '', $file),
                    file_get_contents($file)
                );
            }
        }
        
        $zip->close();
        return true;
    }
    
    return false;
}

// Usage
backup_site_files('/path/to/wordpress', '/path/to/backup.zip');
```

## Database URL Replacement

### WordPress Serialized Data

```php
// Handle serialized data properly
function update_serialized_urls($old_url, $new_url) {
    global $wpdb;
    
    $tables = ['posts', 'postmeta', 'options', 'comments'];
    
    foreach ($tables as $table) {
        $full_table = $wpdb->prefix . $table;
        
        // Simple text replacement
        $wpdb->query(
            $wpdb->prepare(
                "UPDATE {$full_table} SET %s = REPLACE(%s, %s, %s)",
                $table === 'options' ? 'option_value' : (
                    $table === 'postmeta' ? 'meta_value' : 'post_content'
                ),
                $table === 'options' ? 'option_value' : (
                    $table === 'postmeta' ? 'meta_value' : 'post_content'
                ),
                $old_url,
                $new_url
            )
        );
    }
}
```

### Better Search Replace (Safe)

```php
// Use WordPress CLI for safe replacement
// wp search-replace 'old-url' 'new-url' --dry-run

// Or use this helper function
function safe_url_replace($old_url, $new_url) {
    global $wpdb;
    
    // Get all tables
    $tables = $wpdb->get_results("SHOW TABLES");
    
    foreach ($tables as $table) {
        $table_name = reset((array)$table);
        
        // Get columns
        $columns = $wpdb->get_results("DESCRIBE {$table_name}");
        
        foreach ($columns as $column) {
            $column_name = $column->Field;
            $column_type = $column->Type;
            
            // Only process text columns
            if (strpos($column_type, 'text') !== false || strpos($column_type, 'varchar') !== false) {
                // Update using character replacement
                $wpdb->query(
                    $wpdb->prepare(
                        "UPDATE {$table_name} SET {$column_name} = REPLACE({$column_name}, %s, %s)",
                        $old_url,
                        $new_url
                    )
                );
            }
        }
    }
}
```

## wp-config.php Configuration

```php
// Database settings
define('DB_NAME', 'database_name');
define('DB_USER', 'database_user');
define('DB_PASSWORD', 'database_password');
define('DB_HOST', 'localhost');
define('DB_CHARSET', 'utf8mb4');
define('DB_COLLATE', '');

// URLs
define('WP_HOME', 'https://new-site.com');
define('WP_SITEURL', 'https://new-site.com');

// Security keys (generate new ones)
define('AUTH_KEY',         'put your unique phrase here');
define('SECURE_AUTH_KEY',  'put your unique phrase here');
define('LOGGED_IN_KEY',    'put your unique phrase here');
define('NONCE_KEY',        'put your unique phrase here');
define('AUTH_SALT',        'put your unique phrase here');
define('SECURE_AUTH_SALT', 'put your unique phrase here');
define('LOGGED_IN_SALT',   'put your unique phrase here');
define('NONCE_SALT',       'put your unique phrase here');

// Debug settings
define('WP_DEBUG', false);
define('WP_DEBUG_LOG', false);
define('WP_DEBUG_DISPLAY', false);

// Memory
define('WP_MEMORY_LIMIT', '256M');

// Auto-update
define('AUTOMATIC_UPDATER_DISABLED', true);
define('WP_AUTO_UPDATE_CORE', false);

// Disallow file edits
define('DISALLOW_FILE_EDIT', true);
```

## Permissions

```php
// Correct file permissions
function set_permissions($path) {
    $directories = [
        '/wp-content/uploads' => 0755,
        '/wp-content/cache' => 0755,
        '/wp-content' => 0755,
    ];
    
    $files = [
        '/wp-config.php' => 0444,
        '.htaccess' => 0644,
    ];
    
    // Directories
    foreach ($directories as $dir => $perms) {
        if (is_dir($path . $dir)) {
            chmod($path . $dir, $perms);
        }
    }
    
    // Files
    foreach ($files as $file => $perms) {
        if (file_exists($path . $file)) {
            chmod($path . $file, $perms);
        }
    }
}
```

## Local to Production Migration

### 1. Export Local Database

```bash
mysqldump -u username -p database_name > local_backup.sql
```

### 2. Find and Replace

```bash
# Using WP-CLI
wp search-replace 'http://localhost:8888/mysite' 'https://production.com' local_backup.sql

# Or using sed
sed -i 's|http://localhost:8888/mysite|https://production.com|g' local_backup.sql
```

### 3. Upload Files

```bash
# Using rsync (exclude unnecessary files)
rsync -avz --exclude 'node_modules' --exclude '.git' --exclude 'wp-content/cache' --exclude 'wp-content/uploads/.tmp' /local/path/ user@server:/remote/path/
```

### 4. Import Database

```bash
mysql -u username -p database_name < production_backup.sql
```

## Domain Change Migration

### Update All URLs

```php
// Add to functions.php or run once
function update_all_urls() {
    $old_url = 'https://old-domain.com';
    $new_url = 'https://new-domain.com';
    
    // Posts and pages
    global $wpdb;
    $wpdb->query(
        $wpdb->prepare(
            "UPDATE {$wpdb->posts} SET post_content = REPLACE(post_content, %s, %s)",
            $old_url,
            $new_url
        )
    );
    
    // Excerpts
    $wpdb->query(
        $wpdb->prepare(
            "UPDATE {$wpdb->posts} SET post_excerpt = REPLACE(post_excerpt, %s, %s)",
            $old_url,
            $new_url
        )
    );
    
    // Post meta
    $wpdb->query(
        $wpdb->prepare(
            "UPDATE {$wpdb->postmeta} SET meta_value = REPLACE(meta_value, %s, %s)",
            $old_url,
            $new_url
        )
    );
    
    // Options
    $wpdb->query(
        $wpdb->prepare(
            "UPDATE {$wpdb->options} SET option_value = REPLACE(option_value, %s, %s)",
            $old_url,
            $new_url
        )
    );
    
    // Comments
    $wpdb->query(
        $wpdb->prepare(
            "UPDATE {$wpdb->comments} SET comment_content = REPLACE(comment_content, %s, %s)",
            $old_url,
            $new_url
        )
    );
    
    // GUIDs (important for RSS)
    $wpdb->query(
        $wpdb->prepare(
            "UPDATE {$wpdb->posts} SET guid = REPLACE(guid, %s, %s) WHERE guid LIKE %s",
            $old_url,
            $new_url,
            $old_url . '%'
        )
    );
}

// Run once then remove
// add_action('init', 'update_all_urls');
```

### Hardcoded URLs

```php
// Also search for hardcoded URLs in theme files
// Use WP-CLI
wp search-replace 'old-url' 'new-url' --all-tables --dry-run
```

## SSL Migration

### Force HTTPS

```php
// wp-config.php
define('WP_HOME', 'https://' . $_SERVER['HTTP_HOST']);
define('WP_SITEURL', 'https://' . $_SERVER['HTTP_HOST']);

// Force SSL admin
define('FORCE_SSL_ADMIN', true);

// .htaccess redirect
// <IfModule mod_rewrite.c>
//     RewriteEngine On
//     RewriteCond %{HTTPS} off
//     RewriteRule ^(.*)$ https://%{HTTP_HOST}%{REQUEST_URI} [L,R=301]
// </IfModule>
```

### Mixed Content Fix

```php
// Fix mixed content
function fix_mixed_content() {
    if (is_ssl()) {
        ob_start(function($content) {
            return str_replace(
                ['src="http://', 'href="http://', 'content="http://'],
                ['src="https://', 'href="https://', 'content="https://'],
                $content
            );
        });
    }
}
add_action('plugins_loaded', 'fix_mixed_content');
```

## Post-Migration Checklist

- [ ] Clear all caches
- [ ] Regenerate .htaccess rules
- [ ] Test all pages and links
- [ ] Verify images loading
- [ ] Check forms submission
- [ ] Test admin functionality
- [ ] Verify email sending
- [ ] Check mobile responsiveness
- [ ] Update SSL certificate
- [ ] Configure CDN if applicable
- [ ] Update search engine visibility
- [ ] Update sitemap URL
- [ ] Check redirects from old URLs

## Troubleshooting

### Common Issues

```php
// Database connection error
// Check wp-config.php credentials

// White screen of death
// Enable WP_DEBUG
define('WP_DEBUG', true);
define('WP_DEBUG_LOG', true);
define('WP_DEBUG_DISPLAY', true);

// Missing tables
// Run repair
// define('WP_ALLOW_REPAIR', true);
// Visit /wp-admin/maint/repair.php

// Permalinks broken
// Visit Settings > Permalinks and resave

// Media not loading
// Check wp-content/uploads permissions (755)
// Verify file ownership

// Memory exhausted
define('WP_MEMORY_LIMIT', '512M');
```

### Repair Database

```php
// Enable repair mode
define('WP_ALLOW_REPAIR', true);

// Or via WP-CLI
wp db repair
wp db optimize
```

### Reset Permalinks

```php
// Flush rewrite rules
function reset_permalinks() {
    flush_rewrite_rules();
}
add_action('init', 'reset_permalinks');

// Or via WP-CLI
wp rewrite flush
```

## Migration Plugins

- Duplicator
- All-in-One WP Migration
- UpdraftPlus
- WP Migrate
- Duplicator Pro
- WPvivid
- BackupGuard
